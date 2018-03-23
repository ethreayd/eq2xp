#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"

function main(string qn, int speed)
{
	variable string PrimaryWeapon

	questname:Set["${qn}"]
	echo zone is ${Zone.Name}
	eq2execute merc resume
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]

	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",35]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	wait 20
	Ob_AutoTarget:AddActor["Clockwork Prototype XXIV",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Clockwork Prototype XXVII",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Ancient Clockwork Prototype",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	call DMove -52 3 6 ${speed}
	do
	{
		eq2execute summon
		call CountItem "Ancient Clockwork Hand"
	}
	while (${Return}<1)
	call StopHunt
	Ob_AutoTarget:AddActor["Clockwork Scrounger XVII",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove -41 -10 137 ${speed}
	call DMove 109 -10 142 ${speed}
	call DMove 116 3 3 ${speed}
	call DMove 78 3 -42 ${speed}
	call DMove 43 3 -63 ${speed}
	wait 100
	call Hunt "Clockwork Scrounger XVII" 50 1 TRUE
	wait 100
	call CheckCombat
	do
	{
		eq2execute summon
		wait 10
		call IsPresent "Clockwork Scrounger XVII"
	}
	while (${Return})
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 75 4 -84 ${speed}
	call OpenDoor "Junkyard West Door 01"
	call DMove 69 4 -101 ${speed}
	call DMove 48 4 -93 ${speed}
	call DMove 60 4 -127 ${speed}
	call OpenDoor "Junkyard West Door 03"
	call DMove 70 4 -130 ${speed}
	call DMove 92 3 -119 ${speed}
	call DMove 91 3 -144 ${speed}
	call DMove 166 3 -151 ${speed}
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt",FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	oc !c -Campspot ${Me.Name}
	Ob_AutoTarget:AddActor["The Glitched Guardian 10101",0,TRUE,FALSE]
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
	}
	while (${Return}<1)
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call 2DNav 68 -126
	wait 20
	call OpenDoor "Junkyard West Door 03"
	wait 20
	call 2DNav 51 -129
	call 2DNav 48 -93
	call 2DNav 69 -101
	call 2DNav 70 -90
	wait 20
	call OpenDoor "Junkyard West Door 01"
	wait 20
	call 2DNav 70 -78
	call DMove 111 3 -30 ${speed}
	call DMove 135 3 -44 ${speed}
	PrimaryWeapon:Set["${Me.Equipment[Primary]}"]
	Me.Inventory["Electro-Charged Clockwork Hand"]:Equip
	wait 20
	call OpenDoor "door_hand_lock"
	wait 20
	call CheckCombat
	Me.Inventory["${PrimaryWeapon}"]:Equip
	target "an erratic clockwork"
	wait 20
	call CheckCombat
	call IsPresent "an erratic clockwork"
	if (${Return})
	{
		call MoveCloseTo "an erratic clockwork"
		ogre qh
		Actor[name,"an erratic clockwork"]:DoubleClick
		wait 30
		ogre end qh
	}
	call StopHunt
	call 2DNav 180 -67
	call 2DNav 197 -67
	call WaitByPass "Security Sweeper" -30 -80
	call 2DNav 237 -69
	call Follow2D "Security Sweeper" 237 -13 -215 30
	call 2DNav 237 -219
	call 2DNav 173 -219
	oc !c -Campspot
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
	oc !c ${Me.Name} -letsgo
	eq2execute summon
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call 2DNav 117 -219
	call OpenDoor "Junkyard West Door 04"
	call 2DNav 100 -219
	call ConversetoNPC "Meldrath the Marvelous" 16 82 10 -210 
	call 2DNav 92 -245
	call DMove 87 3 -265 ${speed}
	call DMove 44 3 -272 ${speed}
	call DMove -65 12 -272 ${speed}
	call DMove -71 12 -277 ${speed}
	call DMove -99 13 -279 ${speed}
	call StopHunt
	call DMove -112 11 -278 ${speed}
	Ob_AutoTarget:AddActor["Gearclaw the Collector",0,TRUE,FALSE]
	call DMove -135 8 -278 ${speed}
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
	call ActivateVerb "zone_to_valor" -145 10 -251 "Return to the Entrance"
	OgreBotAPI:Special["${Me.Name}"]
}

atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
 {
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
		call MoveCloseTo "${Speaker}"
		OgreBotAPI:ApplyVerbForWho["${Me.Name}","${Speaker}","Turn Key"]
	
	}
 }
