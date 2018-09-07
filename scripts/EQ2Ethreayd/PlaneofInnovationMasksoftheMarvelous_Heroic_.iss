#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) bool Detected
variable(script) bool Opened
variable(script) bool KeyOn
variable(script) bool AutoRez

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=7
	oc !c -resume
	oc !c -letsgo
	if (!${Script["livedierepeat"](exists)})
		run EQ2Ethreayd/livedierepeat ${NoShiny} TRUE
	 
	if (${setspeed}==0)
	{
		speed:Set[3]
		FightDistance:Set[30]
	}
			
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 50 ${speed} 
	
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Plane of Innovation: Masks of the Marvelous [Heroic]"
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]

	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	oc !c -OgreFollow All ${Me.Name}
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
	call StopHunt
	wait 20
	call DMove -59 -10 133 ${speed} ${FightDistance}
}

function step001()
{
	variable string Named
	Named:Set["Ancient Clockwork Prototype"]
	Ob_AutoTarget:AddActor["Clockwork Prototype XXIV",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Clockwork Prototype XXVII",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	
	call DMove -52 3 6 ${speed} ${FightDistance}
	call DMove -36 3 -65 ${speed} ${FightDistance}
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	oc !c -letsgo
	call CheckCombat
	oc !c -CampSpot
	oc !c -joustout
	call TanknSpank "${Named}"
	oc !c -letsgo
	eq2execute summon
	wait 20
	oc !c -acceptreward
	wait 20
	oc !c -acceptreward
	wait 20
	oc !c -acceptreward
	call DMove -58 3 11 ${speed} ${FightDistance}
	call DMove -41 -10 137 ${speed} ${FightDistance}
}	

function step002()
{
	variable string Named
	Named:Set["Clockwork Scrounger XVII"]
	
	call StopHunt
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	
	call DMove 109 -10 142 ${speed} ${FightDistance}
	call DMove 116 3 3 ${speed} ${FightDistance}
	call DMove 117 3 -43 ${speed} ${FightDistance}
	call CheckCombat
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	oc !c -letsgo
	call DMove 115 3 -35 3
	oc !c -Come2Me ${Me.Name} All 3
	call WaitforGroupDistance 20
	
	oc !c -CampSpot
	oc !c -joustout
	wait 20
	
	oc !c -CS_Set_ChangeCampSpotBy All -70 0 0
	
	call TanknSpank "${Named}" 100
	wait 100
	oc !c -letsgo
	do
	{
		wait 100
		call isGroupAlive
	}
	while (!${Return})
	eq2execute summon
	oc !c -letsgo
	eq2execute summon
	wait 20
	oc !c -acceptreward
	wait 20
	oc !c -acceptreward
	wait 20
	oc !c -acceptreward
}

function step003()
{
	variable int Counter=0
	variable string Named
	Named:Set["The Glitched Guardian 10101"]
	
	call StopHunt
	call DMove 71 3 -81 3
	wait 30
	call CheckCombat
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Pause
	call AutoPassDoor "Junkyard West Door 01" 69 4 -101
	wait 50
	call DMove 48 4 -93 3
	call DMove 60 4 -127 1
	call CheckCombat
	call DMove 48 4 -93 3
	call DMove 60 4 -127 1
	call WaitforGroupDistance 20
	call AutoPassDoor "Junkyard West Door 03" 70 4 -130
	wait 50
	call DMove 92 3 -119 ${speed} ${FightDistance}
	call DMove 95 3 -164 ${speed} ${FightDistance}
	call CheckCombat
	oc !c -CampSpot
	oc !c -joustout
	Ob_AutoTarget:AddActor["whirling gear",0,TRUE,FALSE]
	oc !c -CS_Set_ChangeCampSpotBy All 100 0 0
	wait 100
	eq2execute gsay Set up for "${Named}"
	
	call TanknSpank "${Named}" 200
	oc !c -letsgo
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Resume
	do
	{
		eq2execute summon
		call CountItem "Electro-Charged Clockwork Hand"
		wait 10
		Counter:Inc
	}
	while (${Return}<1 && ${Counter}<5)
	do
	{
		wait 100
		call isGroupAlive
	}
	while (!${Return})
	call StopHunt
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
}

function step004()
{
	variable int Counter=0
	variable float loc0 

	call DMove 135 3 -44 ${speed} ${FightDistance}		
	call OpenChargedDoor
	ExecuteQueued
	target "an erratic clockwork"
	wait 50
	ExecuteQueued
	call CheckCombat ${FightDistance}
	ExecuteQueued
	call IsPresent "an erratic clockwork"
	if (${Return})
	{
		do
		{
		loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
		call DMove 128 3 -38 ${speed} ${FightDistance} TRUE TRUE
		call DMove 134 3 -43 1
		call PKey MOVEFORWARD 1
		call IsPresent "door_hand_lock" 5
		if (${Return})
			call OpenChargedDoor
		call MoveCloseTo "an erratic clockwork"
		wait 20
		call IsPresent "door_hand_lock" 5
		if (${Return})
			call OpenChargedDoor
		ogre qh
		wait 50
		Actor[name,"an erratic clockwork"]:DoubleClick
		wait 300
		ogre end qh
		call CheckStuck ${loc0}
		if (${Return})
			call OpenChargedDoor
		call IsPresent "an erratic clockwork"
		Counter:Inc
		}
		while ((${Return} && ${Counter}<3) && !${Opened})
	}
	call StopHunt
	call DMove 153 3 -62 3 ${FightDistance}
	call DMove 177 4 -66 2 ${FightDistance}
	call DMove 201 -3 -67 1 ${FightDistance}
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Pause
	if ${Script["livedierepeat"](exists)}
		Script["livedierepeat"]:Pause
	Detected:Set[FALSE]
	call WaitByPass "Security Sweeper" -30 -80
	call 2DNav 237 -69
	call Follow2D "Security Sweeper" 237 -13 -215 30
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
	
function step005()
{	
	variable string Named
	Named:Set["Glitched Cell Keeper"]	
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
	if ${Script["livedierepeat"](exists)}
		Script["livedierepeat"]:Resume
	oc !c -CampSpot 
	oc !c -joustout
	eq2execute gsay Set up for ${Named}
	wait 20
	oc !c -CS_Set_ChangeCampSpotBy All -40 0 0
	eq2execute gsay Set up for ${Named}
	call TanknSpank "${Named}" 100
	
	oc !c -letsgo
	eq2execute summon
	if ${Script["autoshinies"](exists)}
		Script["autoshinies"]:Resume
}
	
function step006()
{	
	call StopHunt
	call DMove 125 10 -219 ${speed} ${FightDistance}
	call DMove 118 10 -220 1
	call AutoPassDoor "Junkyard West Door 04" 101 10 -219
	call DMove 82 10 -210 3 ${FightDistance}
	if ${Script["livedierepeat"](exists)}
		Script["livedierepeat"]:Pause
	ogre qh
	call Converse "Meldrath the Marvelous" 32 FALSE TRUE
	wait 100
	ogre end qh
	wait 20
	if ${Script["livedierepeat"](exists)}
		Script["livedierepeat"]:Resume
	call DMove 91 10 -235 1 ${FightDistance}
	call AutoPassDoor "Junkyard West Door 05" 91 10 -247
	
	call DMove 87 3 -265 ${speed} ${FightDistance}
	oc !c -ofol---
	oc !c -ofol---
	oc !c -ofol---
	call DMove 44 3 -272 ${speed} ${FightDistance}
	call DMove -27 3 -278 ${speed} ${FightDistance}
	oc !c -Come2Me ${Me.Name} All 3
	wait 20
	call DMove -59 17 -282 1 ${FightDistance}
	call DMove -72 12 -279 1 ${FightDistance}
	call DMove -97 13 -279 1 ${FightDistance}
}	
	
function step007()
{	
	variable string Named
	Named:Set["Gearclaw the Collector"]
	call StopHunt
	call DMove -112 11 -278 1
	call DMove -142 10 -252 3
	oc !c -Come2Me ${Me.Name} All 3
	call CheckCombat
	wait 50
	call DMove -155 4 -267 3
	wait 20
	;oc !c -cs-jo-ji All Casters
		
	call DMove -136 5 -283 3 30 TRUE FALSE 5
	wait 10
	call DMove -151 3 -284 3 30 TRUE FALSE 5
	;wait 10
	;call DMove -146 5 -277 3 30 TRUE FALSE 5
	;wait 10
	;call DMove -150 5 -266 3 30 TRUE FALSE 5
	
	;oc !c -CampSpot ${Me.Name}
	;oc !c -joustout ${Me.Name}
	;oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_namedca TRUE
	oc !c -UplinkOptionChange Healers checkbox_settings_disablecaststack_ca TRUE
	OgreBotAPI:UseItem_Relay[All,"Brew of Readiness"]
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE"]
	echo "must kill ${Named}"
	call IsPresent "${Named}"
	if (${Return})
	{
		target "${Named}"
		do
		{
			wait 10
			if (${Me.IsDead})
				AutoRez:Set[TRUE]
			echo ${Named} at ${Actor["${Named}"].Health}%
			if (${AutoRez} && ${Actor["${Named}"].Health}<25)
			{
				eq2execute gsay Activating AutoRez
				AutoRez:Set[FALSE]
			}
			if (${Actor["${Named}"].Health}<35 && ${Actor["${Named}"].Health}>33)
				eq2execute gsay AoE Prev
			if (${Actor["${Named}"].Health}<27 && ${Actor["${Named}"].Health}>25)
				eq2execute gsay Prev AoE
			if (${Actor["${Named}"].Health}<19 && ${Actor["${Named}"].Health}>17)
			{
				OgreBotAPI:UseItem_Relay[All,"Tome of the Ascended"]
				OgreBotAPI:UseItem_Relay[All,"Tome of the Planes"]
				eq2execute gsay Next Prev
			}
			if (${Actor["${Named}"].Health}<15 && ${Actor["${Named}"].Health}>13)
				OgreBotAPI:CastAbility["${Me.Name}","Unyielding Will"]
			if (${Actor["${Named}"].Health}<10 && ${Actor["${Named}"].Health}>8)
				eq2execute gsay Last Prev
			if (${Actor["${Named}"].Health}<5 && ${Actor["${Named}"].Health}>3)
				eq2execute gsay Ward DP
			ExecuteQueued
			call IsPresent "${Named}" 100 TRUE
		}
		while ((${Return} || ${Me.InCombatMode}) || ${Me.IsDead})
	}
	
	eq2execute summon
	call StopHunt
	oc !c -acceptreward
	wait 10
	oc !c -acceptreward
	call DMove -140 10 -251 3 30 TRUE
	ogre
	wait 200
	oc !c -acceptreward
	wait 10
	oc !c -acceptreward
	wait 10
	oc !c -acceptreward
	do
	{
		wait 200
		if (${Zone.Name.Equal["Plane of Innovation: Masks of the Marvelous [Heroic]"]})
		{
			call DMove -145 10 -251 1
			OgreBotAPI:Special["All"]
		}
	}
	while (${Zone.Name.Equal["Plane of Innovation: Masks of the Marvelous [Heroic]"]})
	oc !c -Zone
	if ${Script["livedierepeat"](exists)}
		endscript livedierepeat
}

function OpenChargedDoor()
{
	variable string PrimaryWeapon
	echo open door with charged hand
	PrimaryWeapon:Set["${Me.Equipment[Primary]}"]
	Me.Inventory["Electro-Charged Clockwork Hand"]:Equip
	wait 20
	call AutoPassDoor "door_hand_lock" 145 3 -55 TRUE
	wait 20
	call CheckCombat ${FightDistance}
	Me.Inventory["${PrimaryWeapon}"]:Equip
}

atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	if (${Message.Find["shock imminent"]} > 0)
	{
		oc !c -joustout
		oc !c -CS_Set_Formation_MonkeyInMiddle All 20 ${Me.Loc.X} ${Me.Loc.Y} ${Me.Loc.Z} ${Me.Name} TRUE
	}
	
	if (${Message.Find["BREACH!!! ALERT"]} > 0)
	{
		Detected:Set[TRUE]
		echo "Detected in tunnel - restarting"
	}
	if (${Message.Find["Access granted"]} > 0)
	{
		Opened:Set[TRUE]
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
	if (${Message.Find["way to be grounded"]} > 0)
	{
		oc !c -cs-jo-ji All Casters
	}
	;if (${Message.Find["need to turn his key"]} > 0)
	;{
	;	KeyOn:Set[TRUE]
	;	oc !c -joustin ${Me.Name}
	;	QueueCommand call TurnKey "Gearclaw the Collector"
	;}
	
	;if (${Message.Find["Collector is energized"]} > 0)
	;{
	;	KeyOn:Set[FALSE]
	;	oc !c -joustout ${Me.Name}
	;}
}