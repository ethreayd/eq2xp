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

variable(script) string QN
variable(script) string QZ
variable(script) index:string NamedToHunt
variable(script) index:string NamedCoordinates
variable(script) index:bool NamedDone

function HarvestQuest(string HarvestQ)
{
	call CheckQuest "${HarvestQ}" FALSE TRUE
	if (${Return})
	{
		call goZone "The Blinding"
		do
		{
			call Harvest
			call CheckQuest "Recuso Tor: Stocking Up" FALSE TRUE
		}
		while (${Return})
	}
}
function LuclinLandscapingTheBlinding(bool DoNotWait, int Timeout)
{
	NamedToHunt:Insert["Novilog"]
	NamedCoordinates:Insert["-106 307 -811"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["An Ancient Spectre"]
	NamedCoordinates:Insert["434.86 347.73 -505.35"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["A Greater Lightcrawler"]
	NamedCoordinates:Insert["350 145 927"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Cluster"]
	NamedCoordinates:Insert["-476 72 -36"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Cobblerock"]
	NamedCoordinates:Insert["62 9 533"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Ripperback"]
	NamedCoordinates:Insert["-403 6 750"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Deathpetal"]
	NamedCoordinates:Insert["-794 5 797"]
	NamedDone:Insert[FALSE]
	QN:Set["Luclin Landscaping: The Blinding"]
	QZ:Set["The Blinding"]
	call TheHunt ${DoNotWait} ${Timeout}
}

function CheckBlindingNamed()
{
	variable index:string Named
	variable int i
	Named:Insert["Novilog"]
	Named:Insert["An Ancient Spectre"]
	Named:Insert["A Greater Lightcrawler"]
	Named:Insert["Cluster"]
	Named:Insert["Cobblerock"]
	Named:Insert["Ripperback"]
	Named:Insert["Deathpetal"]
	
	for ( i:Set[1] ; ${i} <= ${Named.Used} ; i:Inc )
	{
		call WhereIs "${Named[${i}]}" TRUE
		echo testing "${Named[${i}]} : ${Return}"
	}
}
	
function LuclinLandscapingAurelianCoast(bool DoNotWait, int Timeout)
{
	NamedToHunt:Insert["Glorgan the Hammer"]
	NamedCoordinates:Insert["-96 82 -709"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Klechin Darkfist"]
	NamedCoordinates:Insert["66 79 -569"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Nremum"]
	NamedCoordinates:Insert["-326 3 -104"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Rockskin"]
	NamedCoordinates:Insert["-543 60 65"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Va Din Ra"]
	NamedCoordinates:Insert["-559 34 766"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["Xi Xaui"]
	NamedCoordinates:Insert["-486 7 938"]
	NamedDone:Insert[FALSE]
	NamedToHunt:Insert["The Great Sensate"]
	NamedCoordinates:Insert["354 43 556"]
	NamedDone:Insert[FALSE]
	QN:Set["Luclin Landscaping: Aurelian Coast"]
	QZ:Set["Aurelian Coast"]
	call TheHunt ${DoNotWait} ${Timeout}
}
function TheHunt(bool DoNotWait, int Timeout)
{
	variable int i
	variable int Counter
	variable bool GoHunt
	variable bool Grouped

	echo Launching TheHunt
	if (${Timeout}<1)
		Timeout:Set[5]
	if (${Me.GroupCount}>2)
		Grouped:Set[TRUE]
	else
		Grouped:Set[FALSE]
	
	echo Timeout at ${Timeout}
	echo Grouped at ${Grouped}
	
	echo call CheckQuest "${QN}" ${Grouped}
	call CheckQuest "${QN}" ${Grouped}
	
	if (${Return})
	{
		echo Doing "${QN} (Grouped : ${Grouped})"
		call goZone "${QZ}"
		wait 50
		call waitfor_Zoning
		wait 50
	
		if (${Me.GroupCount}>2)
		{
			echo I am doing a Group Hunt
			Grouped:Set[TRUE]
			
			call GroupToFlag TRUE
		}
		do
		{
			Echo looking for Quest Named (${QN} in ${QZ})
			eq2execute merc resume
			for ( i:Set[1] ; ${i} <= ${NamedToHunt.Used} ; i:Inc )
			{
				call WhereIs "${NamedToHunt[${i}]}" TRUE
				
				echo testing "${NamedToHunt[${i}]}" (${NamedDone[${i}]}) : ${Return}
				if (${Return})
				{
					
					call IsNamedEngaged "${NamedToHunt[${i}]}" TRUE
					if (${Return})
					{
						echo Aborting...
						GoHunt:Set[FALSE]
						call StopHunt
					}
					else
					{
						call CheckPlayerAtCoordinates ${NamedCoordinates[${i}]}
						if (${Return})
						{
							echo ${NamedToHunt[${i}]} is already camped - avoiding it
							return FALSE
							GoHunt:Set[FALSE]
							call StopHunt
						}
						else
						{
							echo hunting ${NamedToHunt[${i}]}
							GoHunt:Set[TRUE]
						}
					}
				}
				else
				{
					GoHunt:Set[FALSE]
					call StopHunt
				}
				wait 10
				call CheckQuest "${QN}" ${Grouped}
				
				if (${GoHunt} && ${Return} && !${NamedDone[${i}]})
				{
					echo Found "${NamedToHunt[${i}]}" at ${NamedCoordinates[${i}]}
					if (${Grouped})
						oc !c -Resume
					else
						oc !c -Resume ${Me.Name}
					if (${OgreBotAPI.KWAble})
						call KWMove ${NamedCoordinates[${i}]}
					else
						call navwrap ${NamedCoordinates[${i}]}
		
					call GroupDistance
					if (${Return}>20 && !${Me.FlyingUsingMount})
						eq2execute gsay "Please nav to me now !"
					
					call CheckPlayer
					if (!${Return})
					{
						call Campfor_NPC "${NamedToHunt[${i}]}"
						NamedDone[${i}]:Set[TRUE]
					}
					call StopHunt
				}
			}
			
			echo checking if in Combat (1)
			do
			{
				wait 10
				call CheckCombat
			}
			while (${Return})
			call CheckQuest "${QN}" ${Grouped}
			if (${Return} && !${DoNotWait})
			{
				i:Set[${Math.Calc64[${Math.Rand[${NamedToHunt.Used}]}+1]}]
				echo got ${i}/${NamedToHunt.Used}
				if (!${NamedDone[${i}]})
				{
					echo checking if ${NamedToHunt[${i}]} (${NamedDone[${i}]}) is already camped ?
					call CheckPlayerAtCoordinates ${NamedCoordinates[${i}]}
					if (${Return})
					{
						echo ${NamedToHunt[${i}]} is already camped - avoiding it
						call StopHunt
						return FALSE
					}
					else
					{
						echo Going to location of ${NamedToHunt[${i}]} at ${NamedCoordinates[${i}]} for camp 
						call navwrap ${NamedCoordinates[${i}]}
						if (${Grouped})
						{
							do
							{
								call GroupDistance
								if (${Return}>20 && !${Me.FlyingUsingMount})
								{
									eq2execute gsay "Please nav to me now !"
									wait 1200
								}
							}
							while (${Return}>20)
						}
						call CheckQuest "${QN}" ${Grouped}
						if (${Return})
						{	
							if (${Grouped})
								oc !c -CampSpot
							else
								oc !c -CampSpot ${Me.Name}
								
							call Campfor_NPC "${NamedToHunt[${i}]}" 1200
							NamedDone[${i}]:Set[${Return}]
							do
							{
								wait 10
								call CheckCombat
							}
							while (${Return})
							if (${Grouped})
								oc !c -letsgo
							else
								oc !c -letsgo ${Me.Name}
							call StopHunt
						}
					}
				}
			}
			echo checking if in Combat (2)
			do
			{
				wait 10
				call CheckCombat
			}
			while (${Return})
			Counter:Inc
			echo Timeout at ${Counter}/${Timeout}
			call CheckQuest "${QN}" ${Grouped}
		}
		while (${Return} && !${DoNotWait} && ${Counter}<${Timeout})
	}
	for ( i:Set[1] ; ${i} <= ${NamedToHunt.Used} ; i:Inc )
	{
		NamedDone:Remove[${i}]
		NamedToHunt:Remove[${i}]
		NamedCoordinates:Remove[${i}]
	}
	echo TheHunt terminated
}
function TheHarvest(string QuestName, int Timeout)
{

}
function TheHeroics_FM(bool Expert)
{
	variable int i
	variable int Counter
	variable bool GoHunt
	variable bool Grouped

	echo Launching The Heroics of Fordel Midst
	
	call goFordelMidst
	wait 50
	call waitfor_Zoning
	wait 50
	if (${Me.GroupCount}<6)
	{
		echo This is not a full Group. ABORTING 
		return FALSE
	}	
	Grouped:Set[TRUE]
	call GroupToFlag TRUE
	ogre ic
	wait 50
	oc !c -ZoneResetAll
	if (!${Expert})
    {
		relay all ExpertZone:Set[FALSE]
		Obj_FileExplorer:Change_CurrentDirectory["ICEthreayd/Blood_of_Luclin/Heroic"]
		Obj_FileExplorer:Scan
		Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Aurelian_Coast_Sambata_Village_Heroic.iss"]
		Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Aurelian_Coast_Maidens_Eye_Heroic.iss"]
		Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Aurelian_Coast_Reishi_Rumble_Event_Heroic.iss"]
		Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Fordel_Midst_The_Listless_Spires_Event_Heroic.iss"]
		;Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Fordel_Midst_Bizarre_Bazaar_Heroic.iss"]
		wait 50
		oc !c -LoadProfile Bol_Heroic
		wait 50
		relay all run EQ2Ethreayd/wrap EquipHeroic
		wait 20
		Obj_InstanceControllerXML:ChangeUIOptionViaCode["loop_list_checkbox",TRUE]
	}
	else
	 {
		relay all ExpertZone:Set[TRUE]
		Obj_FileExplorer:Change_CurrentDirectory["ICEthreayd/Blood_of_Luclin/Expert"]
		Obj_FileExplorer:Scan
		Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Aurelian_Coast_Sambata_Village_Heroic.iss"]
		;Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Aurelian_Coast_Maidens_Eye_Heroic.iss"]
		;Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Aurelian_Coast_Reishi_Rumble_Event_Heroic.iss"]
		;Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Fordel_Midst_The_Listless_Spires_Event_Heroic.iss"]
		;Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Fordel_Midst_Bizarre_Bazaar_Heroic.iss"]
		wait 50
		oc !c -LoadProfile Bol_Heroic
		wait 50
		relay all run EQ2Ethreayd/wrap EquipHeroic
		wait 20
		;Obj_InstanceControllerXML:ChangeUIOptionViaCode["loop_list_checkbox",TRUE]
	}
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",TRUE]
	wait 50
	while (${Script["Buffer:OgreInstanceController"](exists)})
	{
		wait 10
	}
	echo The Heroics of Fordel Midst has ended
	relay all ExpertZone:Set[FALSE]
	return TRUE
}
function TheHeroics_SS()
{
	variable int i
	variable int Counter
	variable bool GoHunt
	variable bool Grouped

	echo Launching The Heroics of Sanctus Seru
	
	call goSanctusSeru
	wait 50
	call waitfor_Zoning
	wait 50
	if (${Me.GroupCount}<6)
	{
		echo This is not a full Group. ABORTING 
		return FALSE
	}	
	Grouped:Set[TRUE]
	call GroupToFlag TRUE
	ogre ic
	wait 50
	oc !c -ZoneResetAll
    Obj_FileExplorer:Change_CurrentDirectory["ICEthreayd/Blood_of_Luclin/Heroic"]
    Obj_FileExplorer:Scan
	Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Sanctus_Seru_Echelon_of_Order_Heroic.iss"]
	Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Sanctus_Seru_Echelon_of_Divinity_Heroic.iss"]
	Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["Sanctus_Seru_Arx_Aeturnus_Event_Heroic.iss"]
	wait 50
	oc !c -LoadProfile Bol_Heroic
	wait 50
	relay all run EQ2Ethreayd/wrap EquipHeroic
	wait 20
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["loop_list_checkbox",TRUE]
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",TRUE]
	wait 50
	while (${Script["Buffer:OgreInstanceController"](exists)})
	{
		wait 10
	}
	echo The Heroics of Sanctus Seru has ended
	return TRUE
}

function TheHeroics_SZ()
{
	variable int i
	variable int Counter
	variable bool GoHunt
	variable bool Grouped

	echo Launching The Heroics of Ssraeshza
	
	call goSs
	wait 50
	call waitfor_Zoning
	wait 50
	if (${Me.GroupCount}<6)
	{
		echo This is not a full Group. ABORTING 
		return FALSE
	}	
	Grouped:Set[TRUE]
	call GroupToFlag TRUE
	ogre ic
	wait 50
	oc !c -ZoneResetAll
    Obj_FileExplorer:Change_CurrentDirectory["ICEthreayd/Blood_of_Luclin/Heroic"]
    Obj_FileExplorer:Scan
	;Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["The_Vault_of_Ssraeshza_Heroic.iss"]
	Obj_InstanceControllerXML:AddInstance_ViaCode_ViaName["The_Venom_of_Ssraeshza_Event_Heroic.iss"]
	wait 50
	oc !c -LoadProfile Bol_Heroic
	wait 50
	relay all run EQ2Ethreayd/wrap EquipHeroic
	wait 20
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["loop_list_checkbox",TRUE]
	Obj_InstanceControllerXML:ChangeUIOptionViaCode["run_instances_checkbox",TRUE]
	wait 50
	while (${Script["Buffer:OgreInstanceController"](exists)})
	{
		wait 10
	}
	echo The Heroics of Ssraeshza has ended
	return TRUE
}
function KorVaXian()
{
	Event[EQ2_onIncomingText]:AttachAtom[HandleKorVaXianEvents]
	oc !c -Letsgo
	call DMove -101 -150 -67 3
	wait 5
	oc !c -UplinkOptionChange All checkbox_settings_movemelee FALSE
	wait 5
	oc !c -CampSpot
	wait 5
	oc !c -CS_Set_Formation_MonkeyInMiddle All 8 ${Me.X} ${Me.Y} ${Me.Z}
	wait 5
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} 15 0 0
	wait 20
	target "Kor Va Xian"
	wait 20
	oc !c -CS_Set_ChangeCampSpotBy ${Me.Name} -15 0 0
	wait 20
	relay all run wrap NavCamp 50
	do
	{
		ExecuteQueued
		wait 10
		call IsPresent "Kor Va Xian" 5000
	}
	while (${Return})
	eq2execute gsay gg
}
function EegutStonegut()
{
	Ob_AutoTarget:AddActor["stone-worked trap",0,FALSE,FALSE]
	
	OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_enabled","TRUE"]
	do
	{
		oc !c -cs-jo-ji All Casters
		call NavPull "a muck digger"
		wait 100
		do
		{
			wait 10
		}
		while (${Me.InCombatMode})
		call IsPresent "Eegut Stonegut" 50
	}
	while (!${Return})
	oc !c -letsgo
}

atom HandleKorVaXianEvents(string Message)
{
	if (${Message.Find["prepares to knock back everyone within"]} > 0)
	{
		QueueCommand call JoustWaitBack ${Actor[Name,"Kor Va Xian"].ID} 15 TRUE 300
	}
}