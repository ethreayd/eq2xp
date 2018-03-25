#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"
variable(script) int speed

function main(int stepstart, int stepstop, int setspeed)
{

	variable int laststep=9
	
	if (${setspeed}==0)
	{
		if (${Me.Archetype.Equal["fighter"]})
			speed:Set[3]
		else
			speed:Set[1]
	}
	else
		speed:Set[${setspeed}]
	
	
	if (${stepstop}==0 || ${stepstop}>${laststep})
	{
		stepstop:Set[${laststep}]
	}
	echo zone is ${Zone.Name}
	call waitfor_Zone "Plane of Innovation: Gears in the Machine [Solo]"
	
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",35]
	
	
	call StartQuest ${stepstart} ${stepstop} TRUE
	
	echo End of Zone reached
}

function step000()
{
	eq2execute merc resume

	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	wait 20
	call DMove 109 -10 142 ${speed}
	call DMove 116 3 3 ${speed}
	call DMove 78 3 -42 ${speed}
}
function step001()
{
	variable string Named
	
	Named:Set["Repair Bot 5000"]
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","TRUE"]
	
	call DMove 36 4 -31 ${speed}
	wait 100
	call Hunt "${named}" 50 1 TRUE
	wait 100
	call CheckCombat
	do
	{
		wait 10
		call IsPresent "${named}"
	}
	while (${Return})
	eq2execute summon
	wait 20
}
function step002()
{
	variable string Named
	
	Named:Set["Power Mechanization"]
	
	eq2execute merc resume
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
		
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 113 3 -29 ${speed}
	call DMove 111 -10 131 ${speed}
	call DMove -9 -10 144 ${speed}
	call DMove -66 -10 99 ${speed}
	call DMove -50 3 25 ${speed}
	call DMove -31 3 -87 ${speed}
	call DMove -28 3 -98 ${speed}
	call OpenDoor "Junkyard East Door 01"
	call DMove -29 4 -106 ${speed}
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","TRUE"]
	wait 20
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]

	call DMove -1 4 -116 ${speed}
	
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	eq2execute summon
	wait 20
}

function step003()
{
	variable string Named
	Named:Set["Toa the Shiny"]
	
	eq2execute merc resume
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
		
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]

	call DMove -44 4 -111 3
	call OpenDoor "Junkyard East Door 03"
	call DMove -55 3 -111 3
	call DMove -94 4 -108 ${speed}
	call DMove -121 3 -93 ${speed}
	call DMove -128 4 -35 ${speed}
	call ActivateVerb "Magnetic Ether Compensator" -128 4 -35 "Gather"
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call DMove -161 4 -81 2
	call DMove -175 4 -96 ${speed}
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove -191 4 -143 ${speed}
	call DMove -193 4 -184 ${speed}
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]

	do
	{
		ExecuteQueued
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	eq2execute summon
	wait 20	
	
}

function step004()
{

	variable string Named
	Named:Set["The Junk Beast"]
	
	eq2execute merc resume
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","FALSE"]
		
	call StopHunt
	
	call DMove -158 4 -198 3
	call OpenDoor "Junkyard East Door 04"
	call DMove -149 4 -197 3
	call DMove -135 4 -198 3
	call OpenDoor "Junkyard East Door 05"
	call DMove -130 4 -199 3
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove -63 5 -200 3
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	
	call DMove -48 4 -186  ${speed}
	call DMove -19 12 -170  ${speed}	
	
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (${Return})
	eq2execute summon
	
	call ActivateVerb "Maelin's Talismanic Whirlgurt" -19 12 -170 "Gather"
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call StopHunt
}
	
function step005()
{		
	eq2execute merc resume
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -130 4 -197 2	
	call OpenDoor "Junkyard East Door 05"
	call DMove -155 4 -196 3	
	call OpenDoor "Junkyard East Door 04"
	call DMove -166 4 -196 3	
	call DMove -188 4 -107 3	
	call DMove -153 3 -72 3
	call DMove -74 3 -111 3
	call DMove -47 4 -111 3
	call OpenDoor "Junkyard East Door 03"
	call DMove -18 4 -110 3
	call DMove -17 4 -121 3
	call DMove 82 10 -210  3
	call Converse "Meldrath the Marvelous" 16 
}

function step006()
{	
	variable string Named
	variable string Avoid
	variable float nb=-1
	Named:Set["The Manaetic Behemoth"]
	Avoid:Set["Manaetic Missile"]
	call StopHunt
	eq2execute merc resume
	
	call DMove 8 4 -121 3
	call OpenDoor "Junkyard East Door 02"
	call DMove 25 4 -122 1
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	call DMove 26 4 -180 2
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","FALSE"]
	
	oc !c -Campspot
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 0 0 -60
	
	Ob_AutoTarget:AddActor["prodding gearlet",0,FALSE,FALSE]
	
	Ob_AutoTarget:AddActor["${Named}",0,FALSE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]

	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
	
	call PKey "ZOOMOUT" 20	
	echo Please Kannkor HELP! Don't know how to deal with circles yet :(
	
	do
	{
		wait 10
		if (${Actor["${Avoid}"].Distance(exists)} && ${Actor["${Avoid}"].Distance} < 30)
			{
				echo  ${Actor["${ActorName}"].Distance}
				;oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 0 0  ${Math.Calc64[${nb}*30]}
				wait 10
				nb:Set[${Math.Calc64[${nb}* -1]]
			}
		call IsPresent "${Named}"
	}
	
	while (${Return})
	
	oc !c ${Me.Name} -letsgo
	
}	
	
function step007()
{	
	variable string Named
	Named:Set["Glitching clockwork"]
	
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove 25 21 -287 ${speed}
	
	Ob_AutoTarget:AddActor["${Named}",0,FALSE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","TRUE","TRUE"]
	
	call Converse "The Great Gear" 16 TRUE
	
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
	
	if (!${Me.Archetype.Equal["fighter"]})
	    OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_movebehind","TRUE"]
	
	do
	{
		wait 10
		call IsPresent "The Great Gear"
	}
	while (${Return})
	
	
	eq2execute summon
	call StopHunt
}

function step008()
{		
	call DMove 46 4 -191 3
	call ActivateVerb "Gyro-stabilized Sorcerous Generator" 46 4 -191 "Gather"
	OgreBotAPI:AcceptReward["${Me.Name}"]
	call DMove 26 4 -212 3
	call DMove 23 4 -123 3
	call DMove 12 4 -122 1
	call OpenDoor "Junkyard East Door 02"
	call DMove 8 4 -121 3
	call DMove -16 4 -110 3
	call DMove -16 4 -122 2
	call Converse "Meldrath the Marvelous" 16 
	OgreBotAPI:AcceptReward["${Me.Name}"]

}
function step009()
{		
	call DMove 8 4 -121 3
	call OpenDoor "Junkyard East Door 02"
	call DMove 25 4 -122 3
	call DMove 26 4 -230 3
	call ActivateVerb "zone_to_valor" 26 4 -230 "Coliseum of Valor"
	OgreBotAPI:Special["${Me.Name}"]
}

atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
 {
	echo Catch Event ${ChatType} ${Message} ${Speaker} ${TargetName} ${SpeakerIsNPC} ${ChannelName} 
    if (${Message.Find["gains an electric charge"]} > 0)
	{
		target ${Me.Name}
		call TargetAfterTime "${Speaker}" 200
	}
 }
