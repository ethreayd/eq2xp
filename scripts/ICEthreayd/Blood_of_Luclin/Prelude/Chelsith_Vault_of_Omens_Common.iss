variable string sZoneShortName="exp16_dun_chelsith_prelude"
variable string sZoneIn_ObjectName="Deep Chelsith"
variable string sZoneName="Deep Chelsith: Vault of Omens [Solo]"

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"


variable string Quest_Name="Light Amongst Shadows: The Vault of Omens"
variable(global) string PQB_IC_Script_Pause="${Script.Filename}"

/*
			
*/

function main(int _StartingPoint=0)
{
	;// This creates all the required variables, and calls "RunInstances". 
	call function_Handle_Startup_Process
}
atom atexit()
{
	echo ${Time}: ${Script.Filename} done
}

objectdef Object_Instance
{
	function:bool RunInstance(int _StartingPoint=0)
	{
		if ${_StartingPoint} == 0
		{
			; ISXOgre:SetDeveloperLevel[0]
			if !${Zone.ShortName.Equal["exp16_dun_chelsith_prelude"]}
			{
				Obj_OgreIH:Actor_Click["${sZoneIn_ObjectName}"]
				wait 20
				OgreBotAPI:ZoneDoor["Deep Chelsith: Vault of Omens [Solo]"]
				wait 30
				call Obj_OgreUtilities.HandleWaitForZoning
			}	
			if !${Zone.ShortName.Equal["exp16_dun_chelsith_prelude"]}
			{
				Obj_OgreIH:Message_FailedZone
				return FALSE
			}
			Ogre_Instance_Controller:ZoneSet
			; if !${Script[Autoquest](exists)}
			; {
			Obj_OgreUtilities.OgreNavLib:Set_AutoLoadMapOnZone[FALSE]
			Obj_OgreUtilities.OgreNavLib:ChangeLoadingPath["AutoQuest/CD"]
			Obj_OgreUtilities.OgreNavLib:LoadMap
			; }
			call Obj_OgreIH.Set_VariousOptions
			call Obj_OgreIH.Set_PriestAscension FALSE

			_StartingPoint:Inc
		}
		
		if ${_StartingPoint} == 1
		{
			call This.Named1 "Adlez the Mighty" "113.308617,-14.439699,-368.089905" "126.483536,-17.963583,-307.870544" "TRUE"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: Adlez the Mighty"]
				return FALSE
			}

			; call Obj_OgreIH.Get_Chest
			; call Obj_OgreIH.Get_Shinies_Nav "-191.640747,2.615812,-93.050957" "?" "100"
			_StartingPoint:Inc
		}
				
		if ${_StartingPoint} == 2
		{
			call This.Named1 "Erskellish Bloodarmor" "480.449066,-19.500891,-407.625458" "522.202576,-19.394535,-422.412628"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Erskellish Bloodarmor"]
				return FALSE
			}
			
			; call Obj_OgreIH.Get_Chest
			; call Obj_OgreIH.Get_Shinies_Nav "-343.332428,38.569485,110.083817" "?" "100"
			_StartingPoint:Inc
		}				
		
		if ${_StartingPoint} == 3
		{
			call This.Named1 "Lucrezzia Mindrazer" "565.294373,-15.957543,67.280205" "471.060577,-21.625641,-1.654038"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: Lucrezzia Mindrazer"]
				return FALSE
			}
			; call Obj_OgreIH.Get_Chest
			; call Obj_OgreIH.Get_Shinies_Nav "-366.725189,42.256893,368.069061" "?" "100"
			_StartingPoint:Inc
		}
		
		
		if ${_StartingPoint} == 4
		{
			call This.Named1 "Zun'Liako'Va" "213.482773,-50.901329,308.939880" "200.387344,-51.240406,257.598572" "TRUE"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#4: Zun'Liako'Va"]
				return FALSE
			}
			; call Obj_OgreIH.Get_Chest
			; call Obj_OgreIH.Get_Shinies_Nav "-211.139343,84.733673,402.047363" "?" "100"
			_StartingPoint:Inc
		}

		if ${_StartingPoint} == 5
		{
			call This.Named2 "Eom'Tek'Zen"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#5: Eom'Tek'Zen"]
				return FALSE
			}
			; call Obj_OgreIH.Get_Chest
			; call Obj_OgreIH.Get_Shinies_Nav "-211.139343,84.733673,402.047363" "?" "100"
			_StartingPoint:Inc
		}
		
		;// Finish zone (zone out)
		if ${_StartingPoint} == 6
		{
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.NavToLoc "747.350586,-100.476425,-1066.433350"
			call Obj_OgreUtilities.HandleWaitForGroupDistance 3
			; call Obj_OgreIH.CD.ZoneOut
			Obj_OgreIH:Actor_Click["Exit"]
			wait 50
			call Obj_OgreUtilities.HandleWaitForZoning
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZoneOut
				return FALSE
			}
			_StartingPoint:Inc
		}
		UIElement[${PQBUI_togglepause_resume}]:SetText[Resume]
		return TRUE
	}
	
	function:bool Named2(string _NamedNPC="Doesnotexist")
	{
		variable point3f PortToSpawnSpot="190.206787,-50.505959,342.101746"
		variable point3f NamedSafeSpot="746.876709,-101.735916,-966.750916"
		variable point3f Dirty_NPC_Update="748.513977,-143.253601,-372.442200"

		Obj_OgreIH:LetsGo

		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		call Obj_OgreUtilities.NavToLoc "${PortToSpawnSpot}"
		call Obj_OgreUtilities.HandleWaitForGroupDistance 3

		Obj_OgreIH:Actor_Click["To Boss 02"]
		wait 20

		if ${QuestJournalWindow.ActiveQuest["${Quest_Name}"](exists)}
		{
			call Obj_OgreUtilities.PreCombatBuff 5
			wait 10
			call Obj_OgreUtilities.NavToLoc "${Dirty_NPC_Update}"
			call Obj_OgreUtilities.HandleWaitForGroupDistance 3
			wait 20
			call Obj_OgreUtilities.HandleWaitForCombatWithNPC
			wait 5
			while ${Actor[Query, Name == "a D.I.R.T.Y. researcher" && Aura == "knockdowntoknees" && Distance < 100](exists)}
			{
				call Obj_OgreUtilities.NavToLoc "${Actor[Query, Name == "a D.I.R.T.Y. researcher" && Aura == "knockdowntoknees" && Distance < 100].Loc}"
				call Obj_OgreUtilities.HandleWaitForGroupDistance 3
				wait 20
				call Obj_OgreUtilities.HandleWaitForCombatWithNPC
				wait 5
				Obj_OgreIH:Actor_Click["a D.I.R.T.Y. researcher"]
				wait 5
				Obj_OgreIH:Actor_Click["a D.I.R.T.Y. researcher"]
			}
		}	

		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		call Obj_OgreUtilities.NavToLoc "${NamedSafeSpot}"
		call Obj_OgreUtilities.HandleWaitForGroupDistance 3
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC
		wait 5

		if !${Actor[exactname,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
			return TRUE
		}
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:SetCampSpot
		wait 5
		Obj_OgreIH:ChangeCampSpot["${Actor[namednpc,"${_NamedNPC}"].Loc}"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10

		Obj_OgreIH:CCS_Actor_Position["${Actor[namednpc,"${_NamedNPC}"].ID}"]
		wait 20		
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC "${_NamedNPC}" ClearTargetIfTargetDistanceOver 50
		wait 10
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
		wait 5
		Obj_OgreIH:LetsGo
		call Obj_OgreIH.Get_Chest
		if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
			return FALSE
		}
		if ${QuestJournalWindow.ActiveQuest["${Quest_Name}"](exists)}
		{
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.PreCombatBuff 5
			wait 10
			call Obj_OgreUtilities.NavToLoc "657.461304,-100.210167,-985.710022"
			call Obj_OgreUtilities.HandleWaitForGroupDistance 3
			wait 20
			call Obj_OgreUtilities.HandleWaitForCombatWithNPC
			wait 5

			Obj_OgreIH:Actor_Click["Uktannu Stone"]
			wait 50
			Obj_OgreIH:Actor_Click["Uktannu Stone"]
			wait 50
		}			
		return TRUE	
	}
	function:bool Named1(string _NamedNPC="Doesnotexist", point3f NamedSafeSpot, point3f Dirty_NPC_Update, bool _Extra=FALSE)
	{
		Obj_OgreIH:LetsGo

		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		call Obj_OgreUtilities.NavToLoc "${NamedSafeSpot}"
		call Obj_OgreUtilities.HandleWaitForGroupDistance 3
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC
		wait 5

		if !${Actor[exactname,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
			return TRUE
		}
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:SetCampSpot
		wait 5
		if ${_Extra}
		{
			Obj_OgreIH:CCS_Actor_Position["${Actor[namednpc,"${_NamedNPC}"].ID}"]
		}
		wait 20
		Actor[namednpc,"${_NamedNPC}"]:DoTarget	
		oc !ci -Crouch ${Me.Name}
		oc !ci -RunWalk ${Me.Name}	
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC "${_NamedNPC}" ClearTargetIfTargetDistanceOver 50
		wait 10
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
		wait 5
		Obj_OgreIH:LetsGo
		oc !ci -Crouch ${Me.Name}
		oc !ci -RunWalk ${Me.Name}
		wait 20	
		call Obj_OgreIH.Get_Chest
		if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
			return FALSE
		}
		if ${QuestJournalWindow.ActiveQuest["${Quest_Name}"](exists)}
		{
			Obj_OgreIH:LetsGo
			if ${_NamedNPC.Equal["Adlez the Mighty"]}
			{
				
				call Obj_OgreUtilities.PreCombatBuff 5
				wait 10
				call Obj_OgreUtilities.NavToLoc "135.499313,-17.890051,-287.742035"
				call Obj_OgreUtilities.HandleWaitForGroupDistance 3
				wait 20
				call Obj_OgreUtilities.HandleWaitForCombatWithNPC
				wait 5
			}
			call Obj_OgreUtilities.PreCombatBuff 5
			wait 10
			call Obj_OgreUtilities.NavToLoc "${Dirty_NPC_Update}"
			call Obj_OgreUtilities.HandleWaitForGroupDistance 3
			wait 20
			call Obj_OgreUtilities.HandleWaitForCombatWithNPC
			wait 5
			while ${Actor[Query, Name == "a D.I.R.T.Y. researcher" && Aura == "knockdowntoknees" && Distance < 100](exists)}
			{
				call Obj_OgreUtilities.NavToLoc "${Actor[Query, Name == "a D.I.R.T.Y. researcher" && Aura == "knockdowntoknees" && Distance < 100].Loc}"
				call Obj_OgreUtilities.HandleWaitForGroupDistance 3
				wait 20
				call Obj_OgreUtilities.HandleWaitForCombatWithNPC
				wait 5
				Obj_OgreIH:Actor_Click["a D.I.R.T.Y. researcher"]
				wait 5
				Obj_OgreIH:Actor_Click["a D.I.R.T.Y. researcher"]
			}	

			if ${_NamedNPC.Equal["Lucrezzia Mindrazer"]}
			{
				call Obj_OgreUtilities.NavToLoc "675.736084,-24.071507,26.189383"
				call Obj_OgreUtilities.HandleWaitForGroupDistance 3
				wait 20
				while ${Actor[Query, Name == "a D.I.R.T.Y. researcher" && Aura == "knockdowntoknees" && Distance < 100](exists)}
				{
					call Obj_OgreUtilities.NavToLoc "675.736084,-24.071507,26.189383"
					call Obj_OgreUtilities.HandleWaitForGroupDistance 3
					wait 20
					call Obj_OgreUtilities.HandleWaitForCombatWithNPC
					wait 5
					Obj_OgreIH:Actor_Click["a D.I.R.T.Y. researcher"]
					wait 5
					Obj_OgreIH:Actor_Click["a D.I.R.T.Y. researcher"]
				}
			}
		}	
		return TRUE	
	}
}