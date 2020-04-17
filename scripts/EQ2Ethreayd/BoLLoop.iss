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
;#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/BoLZones.iss"

function main(bool UseOgreIC)
{
	variable index:string ScriptsToRun
	variable string sQN
	variable int x
	variable int Counter
	ScriptsToRun:Insert["livedierepeat"]
	ScriptsToRun:Insert["autoshinies"]
	ScriptsToRun:Insert["ZoneUnstuck"]
	ScriptsToRun:Insert["Buffer:RZ"]
	ScriptsToRun:Insert["Buffer:RIMovement"]
	ScriptsToRun:Insert["wrap1"]
	ScriptsToRun:Insert["wrap2"]
	ScriptsToRun:Insert["wrap"]
	if (${UseOgreIC})
	{
		oc !c ${Me.Name} -letsgo 
		ScriptsToRun:Insert["ISXRIAssistant"]
	}
	else
		ogre end ic
		
	for ( x:Set[1] ; ${x} <= ${ScriptsToRun.Used} ; x:Inc )
	{
        echo Killing script ${ScriptsToRun[${x}]}
		if ${Script["${ScriptsToRun[${x}]}"](exists)}
			endscript "${ScriptsToRun[${x}]}"
	}
	
	if (${UseOgreIC})
	{
		if (!${Script["OgreICAssistant"](exists)})
			run EQ2Ethreayd/OgreICAssistant
	}
	else
	{
		if (!${Script["ISXRIAssistant"](exists)})
			run EQ2Ethreayd/ISXRIAssistant
		RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
		RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RIMovement.xml"
		RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RZ.xml"
		RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RZm.xml"
	}
	
	call GoDown
	
	call ReturnEquipmentSlotHealth Primary
	if (${Me.IsDead} || (${Return}<11 && ${Return}>0))
	{
		wait 100
		echo --- Reviving (Case 1) ReturnEquipmentSlotHealth Primary at ${Return} or/and I am ${Me.IsDead} DEAD
		if (${UseOgreIC})
		{
			oc !c ${Me.Name} -letsgo 
			oc !c ${Me.Name} -Revive
		}
		else
		{
			RIMUIObj:Revive[${Me.Name}]
		}
		wait 400
	}
	call IsPresent dungeons
	if (!${Return})
	{
		call goto_GH
		if (${Me.InventorySlotsFree}<50)
			call ActionOnPrimaryAttributeValue 1040 Transmute
		if (${Me.InventorySlotsFree}<50)
			call GuildH TRUE
		else
			oc !c ${Me.Name} -Repair
		call getBoLQuests Solo
		call LuclinLandscapingTheBlinding TRUE
		call goFordelMidst
		wait 120
	}
	do
	{
		if (${UseOgreIC})
		{
			if (!${Script["OgreICAssistant"](exists)})
				run EQ2Ethreayd/OgreICAssistant
		}
		else
		{
			if (!${Script["ISXRIAssistant"](exists)})
				run EQ2Ethreayd/ISXRIAssistant
		}
	
		eq2execute merc resume
		wait 50
		if (${Me.IsDead})
			Counter:Inc
		else
			Counter:Set[0]
		if (${Me.IsDead} && ${Counter}>30 )
		{
			
			echo --- Reviving (from script BoLLoop (${UseOgreIC}))
			if (${UseOgreIC})
			{
				ogre end ic
				oc !c ${Me.Name} -letsgo 
				oc !c ${Me.Name} -Revive
			}
			else
			{
				RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
				RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RIMovement.xml"
				RIMUIObj:Revive[${Me.Name}]
			}
			wait 300
			call ReturnEquipmentSlotHealth Primary
			wait 10
			if (${Return}>10)
			{
				echo waiting for death sickness to wear off
				wait 900
				if (${UseOgreIC})
				{
					call RunIC
				}
				else
				{
					RI
					wait 20
					UIElement[RI].FindUsableChild[Start,button]:LeftClick
				}
			}
		}
		
		call ReturnEquipmentSlotHealth Primary
		wait 10
		if (${Return}<11 && ${Return}>0)
		{
			if (${UseOgreIC})
			{
				ogre end ic
				oc !c ${Me.Name} -letsgo 
			
			}
			else
			{
				call RIStop
				call RZStop
			}
			wait 100
			echo --- Need to go to guild to repair gear at ${Return}%
			call goto_GH
			call GuildH TRUE
			wait 100
			call goFordelMidst
		}
		else
		{
			if (${Script["Buffer:RunInstances"](exists)} && ${RI_Var_Bool_Paused})
			{
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
		}
		
		call ReturnEquipmentSlotHealth Primary
		if (${Return}>10)
		{
			oc !c ${Me.Name} checkbox_settings_forcenamedcatab TRUE
			oc !c ${Me.Name} -resume
			if (${UseOgreIC})
			{
				call RunIC
			}
			else
			{
				if (!${Script["Buffer:RZ"](exists)})
				{
					echo starting RZ
					RZ
					wait 30
					UIElement[RZm].FindUsableChild[StartButton,button]:LeftClick
				}
			}
			wait 600
		}
	}
	while (TRUE)
}

	