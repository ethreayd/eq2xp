#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"
variable(script) int speed

function main(int stepstart, int stepstop, int setspeed)
{

	variable int laststep=1
	
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
	call waitfor_Zone "Plane of Disease: Outbreak [Solo]"
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_settings_loot","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_checkhp","TRUE"]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_checkhp",98]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","textentry_autohunt_scanradius",35]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","slider_autotarget_scanradius",30]
	
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
	call DMove 568 82 27 ${speed}
	call DMove 570 83 26 1
	call Converse "Velya" 16
	wait 20
	call DMove 532 82 35 ${speed}
	call Converse "Felkruk" 16
}

function step001()
{
	variable string Named
	Named:Set["Springview Healer"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]

	echo must click on all a Last House Crypt down the path
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	OgreBotAPI:AcceptReward["${Me.Name}"]
}	

function step002()
{
	variable string Named
	Named:Set["Felkruk"]
	eq2execute merc resume

	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove 534 68 -43 ${speed}
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
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
	Named:Set["The Carrion"]
	eq2execute merc resume
		
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
		
	call DMove 125 72 -363 ${speed}
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	Ob_AutoTarget:AddActor["Malarian Larva",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	Me.Inventory["Hirudin Extract"]:Use
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step004()
{
	variable string Named
	Named:Set["pusling leakers"]
	eq2execute merc resume
	call StopHunt
	
	call DMove 296 71 -323 ${speed}
	
	echo green clouds and latchers do deal with>>>

	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
	
function step005()
{	
	variable string Named
	Named:Set["The Flesh Eater"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	Me.Inventory["Hirudin Extract"]:Use
	wait 20
	Ob_AutoTarget:AddActor["putrid pile of flesh",0,TRUE,FALSE]
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
   
	call DMove 227 392 10 ${speed}
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
	eq2execute summon
	wait 300
	OgreBotAPI:AcceptReward["${Me.Name}"]
	eq2execute summon
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}
	
function step006()
{	
	variable string Named
	Named:Set["High Dragoon V'Aliar"]
	eq2execute merc resume	
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove 68 75 -308 ${speed}
	call DMove 35 94 -228 ${speed}
	
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
	Me.Inventory["Damaged Rune of Symbiosis"]:Use
	wait 20
	OgreBotAPI:AcceptReward["${Me.Name}"]
}	
	
function step007()
{	
	variable string Named
	Named:Set["Rallius Rattican"]
	eq2execute merc resume
	call StopHunt
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autohunt_autohunt","TRUE"]
	
	call DMove -128 131 -256 ${speed}
	Ob_AutoTarget:AddActor["${Named}",0,TRUE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE","TRUE"]
	echo must kill "${Named}"
	do
	{
		wait 10
		call IsPresent "${Named}"
	}
	while (!${Return})
	eq2execute summon
	wait 50
	OgreBotAPI:AcceptReward["${Me.Name}"]
}

function step008()
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
	
	call ActivateVerb "zone_to_valor" -119 129 -256 "Coliseum of Valor"
	OgreBotAPI:Special["${Me.Name}"]
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
