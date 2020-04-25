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
	variable string Action
	
	Action:Set["Transmute"]
	echo Launching BoLLoop (with ogre ic : ${UseOgreIC})
	echo killing all running scripts
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
		oc !c -letsgo ${Me.Name}
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
	call RIStop
	call RZStop
	
	call GoDown
	echo cleaning some stuff in my bags by ${Action} them
	call ActionOnPrimaryAttributeValue 996 ${Action}
	call ActionOnPrimaryAttributeValue 1019 ${Action}
	call ActionOnPrimaryAttributeValue 1040 ${Action}
	call ActionOnPrimaryAttributeValue 1248 ${Action}
	call ActionOnPrimaryAttributeValue 1298 Salvage TRUE
	call ActionOnPrimaryAttributeValue 1325 Salvage TRUE
	call ActionOnPrimaryAttributeValue 2596 Salvage TRUE
	call ActionOnPrimaryAttributeValue 2650 Salvage TRUE
	call ActionOnPrimaryAttributeValue 2706 Salvage TRUE
	
	call CheckIfRepairIsNeeded 10
	if (${Me.IsDead} || ${Return})
	{
		wait 100
		echo --- Reviving (Case 1) ReturnEquipmentSlotHealth Primary at ${Return} or/and I am ${Me.IsDead} DEAD
		if (${UseOgreIC})
		{
			oc !c -letsgo ${Me.Name}
			oc !c -Revive ${Me.Name}
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
			call ActionOnPrimaryAttributeValue 1040 ${Action}
		call GuildH TRUE
		call CheckAlreadyDone 60000 BolQuests
		if (!${Return})
			call getBoLQuests Solo
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
				oc !c -letsgo ${Me.Name} 
				oc !c -Revive ${Me.Name}
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
		
		call CheckIfRepairIsNeeded 10
		if (${Return})
		{
			if (${UseOgreIC})
			{
				ogre end ic
				oc !c -letsgo ${Me.Name}
			
			}
			else
			{
				call RIStop
				call RZStop
			}
			wait 100
			echo --- Need to go to guild to repair gear at ${Return}%
			call goto_GH
			oc !c -letsgo ${Me.Name}
			oc !c -Resume ${Me.Name}
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
			if (${Me.InventorySlotsFree}<50)
				call ActionOnPrimaryAttributeValue 1040 ${Action}
		
			oc !c -UplinkOptionChange ${Me.Name} checkbox_settings_forcenamedcatab TRUE
			oc !c -resume ${Me.Name}
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
	}
	while (TRUE)
}

	