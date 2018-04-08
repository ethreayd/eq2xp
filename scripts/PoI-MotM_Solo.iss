#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"
variable(script) int speed
variable(script) int FightDistance

function main(int stepstart, int stepstop, int setspeed)
{

	variable int laststep=7
	
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
	call waitfor_Zone "Plane of Innovation: Masks of the Marvelous [Solo]"
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_moveinfront","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",${FightDistance}]
	OgreBotAPI:AutoTarget_SetScanRadius["${Me.Name}",30]
	
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

	Ob_AutoTarget:AddActor["Clockwork Prototype XXIV",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Clockwork Prototype XXVII",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Ancient Clockwork Prototype",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	
	call DMove -52 3 6 ${speed} ${FightDistance}
	call DMove -35 3 -88 ${speed} ${FightDistance}
	do
	{
		eq2execute summon
		call CountItem "Ancient Clockwork Hand"
	}
	while (${Return}<1)
}	

function step002()
{
	eq2execute merc resume

	call StopHunt
	Ob_AutoTarget:AddActor["Clockwork Scrounger XVII",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove -41 -10 137 ${speed} ${FightDistance}
	call DMove 109 -10 142 ${speed} ${FightDistance}
	call DMove 116 3 3 ${speed} ${FightDistance}
	call DMove 78 3 -42 ${speed} ${FightDistance}
	call DMove 43 3 -63 ${speed} ${FightDistance}
	wait 100
	call Hunt "Clockwork Scrounger XVII" 50 1 TRUE
	wait 100
	call CheckCombat ${FightDistance}
	do
	{
		eq2execute summon
		wait 10
		call IsPresent "Clockwork Scrounger XVII"
	}
	while (${Return})
}

function step003()
{
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
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","FALSE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	oc !c -Campspot ${Me.Name}
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
	oc !c ${Me.Name} -letsgo
	do
	{
		eq2execute summon
		call CountItem "Electro-Charged Clockwork Hand"
		wait 10
	}
	while (${Return}<1)
}

function step004()
{
	variable string PrimaryWeapon
	variable int Counter=0
	eq2execute merc resume
	
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
		

	PrimaryWeapon:Set["${Me.Equipment[Primary]}"]
	Me.Inventory["Electro-Charged Clockwork Hand"]:Equip
	wait 20
	call OpenDoor "door_hand_lock"
	wait 20
	call CheckCombat ${FightDistance}
	Me.Inventory["${PrimaryWeapon}"]:Equip
	target "an erratic clockwork"
	wait 50
	call CheckCombat ${FightDistance}
	call IsPresent "an erratic clockwork"
	if (${Return})
	{
		do
		{
		call MoveCloseTo "an erratic clockwork"
		wait 20
		ogre qh
		wait 50
		Actor[name,"an erratic clockwork"]:DoubleClick
		wait 300
		ogre end qh
		call IsPresent "an erratic clockwork"
		Counter:Inc
		}
		while (${Return} && ${Counter}<3)
	}
	call StopHunt
	call DMove 153 3 -62 3 ${FightDistance}
	call DMove 177 4 -66 2 ${FightDistance}
	call DMove 201 -3 -67 1 ${FightDistance}
	call WaitByPass "Security Sweeper" -30 -80
	call 2DNav 237 -69
	call Follow2D "Security Sweeper" 237 -13 -215 30
	call 2DNav 237 -219
	call 2DNav 173 -219
}
	
function step005()
{	
	eq2execute merc resume
		
	oc !c -Campspot ${Me.Name} 
	eq2execute gsay Set up for Glitched Cell Keeper
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -40 0 0
	Ob_AutoTarget:AddActor["Glitched Cell Keeper",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	do
	{
		wait 10
		call IsPresent "Glitched Cell Keeper"
	}
	while (${Return})
	oc !c -letsgo ${Me.Name}
	eq2execute summon
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
}	
	
function step007()
{	
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -112 11 -278 1
	Ob_AutoTarget:AddActor["Gearclaw the Collector",0,TRUE,FALSE]
	call DMove -135 8 -278 1
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movemelee","TRUE"]
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	do
	{
		wait 10
		call IsPresent "Gearclaw the Collector"
	}
	while (${Return})
	eq2execute summon
	call StopHunt
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call ActivateVerb "zone_to_valor" -145 10 -251 "Return to the Entrance" TRUE
	call ActivateVerb "zone_to_valor" -145 10 -251 "Colisseum of Valor" TRUE
	OgreBotAPI:AcceptReward["${Me.Name}"]
	OgreBotAPI:AcceptReward["${Me.Name}"]
	do
	{
		wait 200
		OgreBotAPI:Special["${Me.Name}"]
	}
	while (!${Zone.Name.Equal["Colisseum of Valor"]})
}

atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
 {
	echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
    if (${Message.Find["begins to overheat"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -40 0 0
	
	}
	if (${Message.Find["engaging hostile entities"]} > 0)
	{
		oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 40 0 0
	}
	if (${Message.Find["need to turn his key"]} > 0)
	{
		press MOVEFORWARD
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${Speaker}","Turn Key"]
		press MOVEFORWARD
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${Speaker}","Turn Key"]
		press MOVEFORWARD
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${Speaker}","Turn Key"]
		press MOVEFORWARD
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${Speaker}","Turn Key"]
		press MOVEFORWARD
	}
 }
