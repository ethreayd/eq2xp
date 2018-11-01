#define AUTORUN "num lock"
#define CENTER p
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
#define PAGEUP "Page Up"
#define PAGEDOWN "Page Down"
#define WALK shift+r
#define ZOOMIN "Num +"
#define ZOOMOUT "Num -"
#define JUMP Space
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
variable(script) int speed
variable(script) int FightDistance
variable(script) int CurrentStep=0
variable(script) bool StatueOn=FALSE

function main(int stepstart, int stepstop, int setspeed, bool NoShiny)
{

	variable int laststep=5
	oc !c -LoadProfile Solo ${Me.Name}
	wait 150
	call SoloLetsgo
	if (!${Script["livedierepeat"](exists)})
		run EQ2Ethreayd/livedierepeat ${NoShiny}
	if ${Script["autopop"](exists)}
		Script["autopop"]:Pause
	if (${setspeed}==0)
	{
		speed:Set[3]
		FightDistance:Set[30]
	}
	else
		speed:Set[${setspeed}]
			
	echo speed set to ${speed}
	if ${Script["autoshinies"](exists)}
		endscript autoshinies
	if (!${Script["ToonAssistant"](exists)})
		relay all run EQ2Ethreayd/ToonAssistant
	
	if (!${NoShiny})
		run EQ2Ethreayd/autoshinies 50 ${speed} 
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "The Fabled Ruins of Guk: Halls of the Fallen [Solo]"

	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_onAnnouncement]:AttachAtom[HandleAnnounces]
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
	OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
		
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Quest reached
}

function step000()
{
	variable string Named
	Named:Set["an Ancient Fungoid"]
	call SoloFollow
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove -9 0 -5 3
	call DMove 22 -6 16 3
	call DMove 61 -14 10 3
	call DMove 72 -16 -15 3
	call DMove 68 -23 -49 3
	call DMove 68 -33 -81 3
	call DMove 41 -33 -108 3
	call DMove 64 -33 -133 3
	call DMove 44 -32 -143 3
	call DMove 40 -39 -163 3
	call DMove 41 -33 -143 3
	call DMove 71 -32 -138 3
	call DMove 71 -35 -186 3
	call waitfor_Power 98
	call waitfor_Health 98
	call DMove 102 -37 -195 3
	call TanknSpank "${Named}" 100
	call SoloLetsgo 
	wait 100
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call DMove 104 -37 -195 3
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call waitfor_Power 50
	call waitfor_Health 98
	CurrentStep:Inc
}

function step001()
{
	variable string Named
	variable int Counter
	Named:Set["Rideepa the Prideful"]
	call SoloFollow
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 90 -35 -199 3
	call DMove 96 -35 -207 3 30 FALSE FALSE 3 
	do
	{
		OgreBotAPI:Special["${Me.Name}"]
		wait 20
		call CountItem "pure fungus"
	}
	while (${Return}<1)
	call DMove 81 -37 -183 3
	call DMove 68 -33 -168 3
	call DMove 71 -32 -133 3
	call DMove 69 -40 -112 3
	do
	{
		OgreBotAPI:Special["${Me.Name}"]
		wait 20
		call CountItem "pure fungus"
		Counter:Inc
	}
	while (${Return}>0 && ${Counter}<30)
	call DMove 73 -40 -121 1 30 FALSE FALSE 2
	call DMove 81 -32 -128 3 30 FALSE FALSE 5
	call DMove 106 -32 -115 3 
	wait 20
	call DMove 133 -41 -138 3
	wait 20
	call DMove 145 -44 -157 3
	call DMove 129 -41 -164 3
	oc !c -ofol--- ${Me.Group[1].Name}
	oc !c -ofol--- ${Me.Group[1].Name}
	oc !c -ofol--- ${Me.Group[1].Name}
	call DMove 141 -41 -183 3
	call DMove 151 -43 -186 3
	call DMove 166 -51 -173 3
	call DMove 176 -57 -195 3
	call DMove 173 -61 -212 3
	call DMove 160 -61 -216 3
	call DMove 164 -61 -238 3 30 TRUE FALSE 10
	oc !c -CampSpot ${Me.Name}
	call TanknSpank "${Named}" 100
	call SoloLetsgo
	wait 100
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call waitfor_Power 50
	CurrentStep:Inc
}
function step002()
{
	variable string Named
	variable int ActorID
	Named:Set["Froppit the Everliving"]
	call SoloFollow
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]

	call DMove 175 -61 -237 3 30 FALSE FALSE 5
	call DMove 173 -62 -242 1 30 FALSE FALSE 2
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call PKey F9 10
	call ActivateVerbOnPhantomActor "Move"
	ActorID:Set[${Return}]
	wait 20
	
	call DMove 173 -61 -242 3
	call DMove 175 -52 -176 3
	call DMove 161 -49 -174 3
	call DMove 146 -43 -185 3
	call DMove 131 -42 -170 3
	call DMove 132 -42 -171 1 30 TRUE TRUE 2
	call DMove 146 -45 -156 3
	call DMove 118 -36 -119 3
	call DMove 97 -32 -110 3
	call DMove 68 -32 -91 3
	call DMove 32 -32 -115 3
	StatueOn:Set[FALSE]
	do
	{
		call DMove 19 -32 -97 3
		call DMove 10 -32 -96 3 30 TRUE TRUE 2
		face 6 -30 -97
		call PKey CENTER 1
		call PKey PAGEDOWN 20
		call PKey PAGEUP 5
		call ClickZone 680 380 1680 730 50
		call PKey F9 10
		call ActivateVerbOnPhantomActor "Examine"
	}
	while (!${StatueOn})
	
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	call DMove 25 -32 -106 3
	call DMove 22 -33 -139 3
	call DMove 46 -34 -151 3
	call DMove 37 -39 -173 3
	call DMove 2 -39 -172 3
	call DMove -9 -40 -197 3
	call DMove -27 -39 -185 3
	call DMove -48 -39 -166 3
	call DMove -106 -39 -158 3 30 TRUE
	call DMove -136 -46 -195 3 30 TRUE
	call DMove -127 -46 -208 3 30 TRUE
	call DMove -120 -40 -164 3 30 TRUE
	call DMove -97 -39 -147 3 30 TRUE 
	call DMove -66 -53 -218 3 30 TRUE
	call DMove -92 -53 -243 3 30 TRUE
	oc !c -CampSpot ${Me.Name}
	
	call TanknSpank "${Named}"
	call waitfor_Power 50
	call SoloLetsgo 
	call SoloFollow
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 100
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	CurrentStep:Inc
}
function step003()
{
	variable string Named
	Named:Set["Molinap the Destructor"]
	call SoloFollow
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]

	call DMove -89 -53 -244 3 30 TRUE FALSE 2
	call DMove -89 -43 -263 3 30 TRUE FALSE 5
	call DMove -56 -43 -259 1 30 FALSE FALSE 3
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call SoloFollow
	face -54 -43 -260
	call PKey F9 5
	call PKey PAGEDOWN 20
	call PKey PAGEUP 5
	MouseTo 1000,750
	wait 10
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	wait 1
	Mouse:LeftClick
	Mouse:LeftClick
	wait 2
	Mouse:LeftClick
	Mouse:LeftClick
	wait 50
	MouseTo 770,450
	wait 10
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	wait 1
	Mouse:LeftClick
	Mouse:LeftClick
	wait 2
	Mouse:LeftClick
	Mouse:LeftClick
	wait 50
	MouseTo 1160,440
	wait 10
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	wait 1
	Mouse:LeftClick
	Mouse:LeftClick
	wait 2
	Mouse:LeftClick
	Mouse:LeftClick
	wait 50
	
	call PKey F9 5
	call DMove -89 -53 -244 3 30 TRUE FALSE 2
	call DMove -89 -43 -263 3 30 TRUE FALSE 5
	call DMove -56 -43 -259 1 30 FALSE FALSE 3
	face -54 -43 -260
	call PKey F9 5
	call PKey PAGEDOWN 20
	call PKey PAGEUP 5
	
	MouseTo 1000,750
	wait 10
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	wait 1
	Mouse:LeftClick
	Mouse:LeftClick
	wait 2
	Mouse:LeftClick
	Mouse:LeftClick
	wait 50
	MouseTo 770,450
	wait 10
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	wait 1
	Mouse:LeftClick
	Mouse:LeftClick
	wait 2
	Mouse:LeftClick
	Mouse:LeftClick
	wait 50
	MouseTo 1160,440
	Mouse:LeftClick
	Mouse:LeftClick
	wait 50
	call PKey F9 5
	call DMove -89 -53 -244 3 30 TRUE FALSE 2
	call DMove -89 -43 -263 3 30 TRUE FALSE 5
	call DMove -56 -43 -259 1 30 FALSE FALSE 3
	face -54 -43 -260
	call PKey F9 5
	call PKey PAGEDOWN 20
	call PKey PAGEUP 5
	MouseTo 1000,750
	wait 10
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	wait 1
	Mouse:LeftClick
	Mouse:LeftClick
	wait 2
	Mouse:LeftClick
	Mouse:LeftClick
	wait 50
	MouseTo 770,450
	wait 10
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	Mouse:LeftClick
	wait 1
	Mouse:LeftClick
	Mouse:LeftClick
	wait 2
	Mouse:LeftClick
	Mouse:LeftClick
	wait 50
	MouseTo 1160,440
	Mouse:LeftClick
	Mouse:LeftClick
	wait 50
	call PKey F9 5
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	call DMove -81 -43 -260 3
	call DMove -79 -50 -284 3
	call DMove -90 -58 -273 3
	call DMove -97 -58 -289 3
	call DMove -70 -66 -300 3
	call DMove -86 -66 -306 3
	call DMove -66 -69 -340 3
	press -hold Space
	do
	{
		call DMove -45 -69 -340 3
		call DMove -25 -69 -323 3
		press -release Space
		call PKey FLYDOWN 20
		call ActivateVerb "An Old Chest" -23 -74 -328 "Open the chest"
		wait 10
		call CountItem "Shiny Golden Trinket"
	}
	while (${Return}==0)
	call PKey Space 20
	call DMove -18 -69 -335 3
	call DMove -33 -69 -352 3
	call DMove -53 -70 -349 1
	call DMove -69 -65 -358 3
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call DMove -47 -62 -370 3
	call DMove -5 -55 -364 3
	call DMove -11 -51 -312 3
	call DMove -37 -49 -318 3
	call DMove -75 -43 -314 3
	call DMove -89 -41 -337 3
	call DMove -83 -41 -372 3
	call DMove -28 -33 -370 3 FALSE TRUE
	wait 20
	call DMove -18 -32 -380 3 FALSE TRUE
	oc !c -CampSpot ${Me.Name}
	oc !c -CampSpot ${Me.Group[1].Name}
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -60 0 -6
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Group[1].Name} -60 0 -6
	call TanknSpank "${Named}" 100
	wait 100
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call waitfor_Power 50
	CurrentStep:Inc
	call StopHunt
	call SoloLetsgo
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove -22 -32 -378 3 30 FALSE TRUE
	call DMove -46 -68 -322 3 30 TRUE TRUE
	eq2execute merc backoff
	call DMove -25 -69 -323 3 30 FALSE TRUE
	call DMove -18 -69 -335 3 30 FALSE TRUE
	call DMove -33 -69 -352 3 30 FALSE TRUE
	call DMove -53 -70 -349 1 30 FALSE TRUE
	call DMove -69 -65 -358 3
	call DMove -47 -62 -370 3
	call DMove -5 -55 -364 3
	call DMove -11 -51 -312 3
	call DMove -37 -49 -318 3
	call DMove -75 -43 -314 3
	call DMove -89 -41 -337 3
	call DMove -83 -41 -372 3
	call DMove -28 -33 -370 3
	call DMove -15 -31 -383 3
	call DMove 0 -32 -357 3
	call DMove -10 -33 -325 3
	call DMove 3 -34 -323 1
	call DMove 32 -34 -325 3
	call DMove 27 -61 -304 3
}
function step004()
{
	variable string Named
	Named:Set["a Ghoul Usurper"]
	
	call SoloFollow
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove 34 -60 -279 3
	call DMove 7 -60 -280 3
	call DMove 8 -60 -256 3
	call DMove -22 -60 -255 3
	call DMove 10 -60 -250 3
	call DMove 10 -60 -235 3
	call DMove 40 -60 -232 3
	call DMove 32 -60 -264 3
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call PKey CENTER 1
	call PKey F9 10
	call MoveCloseTo "a froglok body"
	call GetObject "a froglok body" "Move"
	call DMove 34 -60 -279 3
	call DMove 7 -60 -280 3
	StatueOn:Set[FALSE]
	do
	{
		call DMove 8 -60 -256 3
		call DMove -22 -60 -255 1 30 FALSE FALSE 3
		MouseTo 1011,298
		wait 10
		Mouse:LeftClick
		Mouse:LeftClick
		wait 10
		call ClickZone 700 470 1650 670 50
	}
	while (!${StatueOn})
	call PKey F9 10
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	call DMove 8 -60 -247 3
	call DMove 16 -60 -231 3
	call DMove 38 -60 -229 3
	call DMove 44 -60 -255 3
	call DMove 105 -64 -251 3
	call DMove 68 -60 -250 3
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call PKey CENTER 1
	call PKey F9 10
	call MoveCloseTo "a froglok body"
	call GetObject "a froglok body" "Move"
	StatueOn:Set[FALSE]
	do
	{
		call DMove 106 -64 -251 1 30 FALSE FALSE 3
		MouseTo 462,476
		wait 10
		Mouse:LeftClick
		Mouse:LeftClick
		wait 10
		call ClickZone 580 450 1650 670 50
	}
	while (!${StatueOn})
	call PKey F9 10
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
	call DMove 102 -64 -232 3
	call DMove 124 -65 -232 3
	call DMove 120 -65 -269 3
	call DMove 150 -64 -250 3
	call DMove 152 -64 -257 3 30 FALSE FALSE 5
	call DMove 122 -64 -262 3
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Pause
	call PKey CENTER 1
	call PKey F9 10
	call MoveCloseTo "a froglok body"
	call GetObject "a froglok body" "Move"
	StatueOn:Set[FALSE]
	do
	{
		call DMove 150 -64 -250 3
		call DMove 151 -64 -255 1 30 FALSE FALSE 3
		face 152 -258
		MouseTo 462,476
		wait 10
		Mouse:LeftClick
		Mouse:LeftClick
		wait 10
		call ClickZone 460 470 1650 670 50
	}
	while (!${StatueOn})
	call PKey F9 10
	
	call TanknSpank "${Named}" 100
	
	call SoloLetsgo
	wait 100
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call waitfor_Power 50
	CurrentStep:Inc
	if ${Script["autoshinies"](exists)}
			Script["autoshinies"]:Resume
}
function step005()
{
	variable string Named
	Named:Set["Lord Kurpep"]
	
	call SoloFollow
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 150 -64 -255 3
	call DMove 121 -65 -271 3
	call DMove 125 -64 -291 3 30 FALSE FALSE 5
	
	call DMove 146 -64 -307 3
	call DMove 105 -64 -308 3
	call DMove 125 -64 -313 3
	call DMove 124 -68 -332 3
	wait 20
	call DMove 127 -68 -362 3
	wait 20
	call DMove 124 -68 -344 3
	oc !c -CampSpot ${Me.Name}
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 0 0 -40
	call TanknSpank "${Named}" 100
	
	call SoloLetsgo
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	if ${Script["autopop"](exists)}
		Script["autopop"]:Resume
}
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
	if (${Speaker.Equal["Molinap the Destructor"]})
	{
		Me.Inventory["Shiny Golden Trinket"]:Use
	}
	if (${Message.Find["t see target"]} > 0 || ${Message.Find["oo far away"]} > 0)
	{
		 oc !c -Come2Me ${Me.Name} ${Speaker} 3
	}
}
atom HandleAllEvents(string Message)
{
	if (${Message.Find["his squat statue resembles a troll warrior"]} > 0)
	{
		StatueOn:Set[TRUE]
	}
	if (${Message.Find["cadaverous body of a cursed Guk froglok"]} > 0)
	{
		StatueOn:Set[TRUE]
	}
	if (${Message.Find["ou are drowning"]} > 0)
	{
		QueueCommand call PKey Space 20
	}
}
