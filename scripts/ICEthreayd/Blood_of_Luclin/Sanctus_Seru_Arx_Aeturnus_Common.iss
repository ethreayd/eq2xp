variable string sZoneShortName="exp16_dun_sanctus_seru_01"
;// variable string sZoneIn_ObjectName="zone_to_pow"

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

/*
	
	
*/

function main(int _StartingPoint=0)
{
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
		; Obj_OgreIH:Set_Debug_Mode
		if ${_StartingPoint} == 0
		{
			call Obj_OgreIH.ZoneNavigation.GetIntoZone "${sZoneName}" "${sDifficulty}"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone
				return FALSE
			}
						
			wait 20
			Ogre_Instance_Controller:ZoneSet
			
			call Obj_OgreIH.Set_VariousOptions
			call Obj_OgreIH.Set_PriestAscension FALSE
			
			Obj_OgreIH:Set_NoMove
			_StartingPoint:Inc
		}

		if ${_StartingPoint} == 1
		{
			call This.Named1 "Archon of Life" "a toxic Luminary" "an aqueous Luminary" "a frigid Luminary" "a sanguinated Luminary"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#1: Archon of Life"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
			;// Once this guy is dead, lets wait a short amount of time for the next set of adds to spawn
			wait 50
			;// 5 seconds be good? no idea.
		}

		if ${_StartingPoint} == 2
		{
			call This.Named2 "Archon of Death"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#2: Archon of Death"]
				return FALSE
			}
			
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
		}
		
		if ${_StartingPoint} == 3
		{
			call This.Named3 "Sanctus Eternus"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#4: Sanctus Eternus"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
		}
		
		;// Finish zone (zone out)
		if ${_StartingPoint} == 4
		{
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.NavToLoc "51.519939,77.969246,4.609105"
			call Obj_OgreUtilities.HandleWaitForGroupDistance 3
			call Obj_OgreIH.ZoneNavigation.ZoneOut
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZoneOut
				return FALSE
			}
			_StartingPoint:Inc
		}
		
		return TRUE
	}
	
	function:bool Named3(string _NamedNPC="Doesnotexist")
	{	
		Obj_OgreIH:ChangeCampSpot["22.685085,78.122375,31.97125"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		

		Obj_OgreIH:ChangeCampSpot["51.595081,77.957047,32.390129"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10

		Obj_OgreIH:ChangeCampSpot["52.472740,77.969238,3.826474"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		

		Obj_OgreIH:ChangeCampSpot["79.357643,77.969238,4.041197"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		
		call Obj_OgreIH.KillAll "${_NamedNPC}" "-SetUpFor" "-PreBuff" 50
		
		wait 10
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
			
		if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
			return FALSE
		}
		echo ${Time}: EndNamed3
		
		return TRUE	
	}
	function:bool Named2(string _NamedNPC="Doesnotexist")
	{
		wait 500 ${Actor[exactname,"a dire Luminary"].ID(exists)}
		if ${Actor[exactname,"a dire Luminary"].ID(exists)}
			wait 500
		call Obj_OgreUtilities.PreCombatBuff 5
		call Obj_OgreIH.KillAll "a dire Luminary" -StopWhenNamedNPCSpawns "${_NamedNPC}"
		wait 5 ${Actor[exactname,"${_NamedNPC}"].ID(exists)}
		if !${Actor[exactname,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
			return TRUE
		}

		Obj_OgreIH:SetCampSpot

		if !${Me.IsHated}
			call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:SetUpFor
		wait 5
		Actor[exactname,"${_NamedNPC}"]:DoTarget
		wait 20
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC "${_NamedNPC}" ClearTargetIfTargetDistanceOver 100
		wait 10
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
			
		if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
			return FALSE
		}
		
		return TRUE	

	}
	function:bool Named1(string _NamedNPC="Doesnotexist", string Trash1, string Trash2, string Trash3, string Trash4)
	{
		Obj_OgreIH:SetCampSpot
		Obj_OgreIH:ChangeCampSpot["-81.900337,78.122375,3.701022"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreIH.Select_Zone_Version "auto" "normal"
		wait 10
		Obj_OgreIH:ChangeCampSpot["-52.729069,78.122383,4.174734"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		variable index:Object_Named1Trash Obj_Trash
		; These stupid fucking adds can be in any order.. lol - but each one is always at the same place
		variable int Health1=76
		variable int Health2=51
		variable int Health3=26
		;// Just need some value here
		variable int Health4=26

		variable int iCounter2
		variable int iCounter
		variable uint ActorID
		variable bool bBehind=FALSE

		for ( iCounter2:Set[1] ; ${iCounter2} <= 4 ; iCounter2:Inc )
		{
			for ( iCounter:Set[1] ; ${iCounter} <= 4 ; iCounter:Inc )
			{
				if ${Actor["${Trash${iCounter}}"].ID(exists)}
				{
					echo ${Time}: ${iCounter2}: Obj_Trash:Insert["${Actor["${Trash${iCounter}}"].Name}","${Actor["${Trash${iCounter}}"].Loc}",${Health${iCounter2}}]
					Obj_Trash:Insert["${Actor["${Trash${iCounter}}"].Name}","${Actor["${Trash${iCounter}}"].Loc}",${Health${iCounter2}}]
					call Obj_OgreUtilities.HandleWaitForCampSpot 10
					call Obj_OgreIH.KillAll "${Trash${iCounter}}"
					wait 50
					break
				}
			}
		}
		echo ${Time}: Trash all done
		wait 50 ${Actor[exactname,"${_NamedNPC}"].ID(exists)}
		if !${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
			return TRUE
		}
		if ${Obj_Trash.Used} != 4
		{
			Obj_OgreIH:Message["On ${_NamedNPC} and do not know the order"]
			return FALSE
		}

		Ob_AutoTarget:AddActor["a frigid luminary",20,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a toxic luminary",20,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a sanguinated luminary",20,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an aqueous luminary",20,FALSE,TRUE]
		
		ActorID:Set[${Actor[namednpc,"${_NamedNPC}"].ID}]
		Obj_OgreIH:CCS_Actor_Position[${ActorID}]
		Actor[id,${ActorID}]:DoTarget
		
		wait 50

		for ( iCounter:Set[1] ; ${iCounter} <= 4 ; iCounter:Inc )
		{
			bBehind:Set[FALSE]
			Obj_OgreIH:CCS["${Obj_Trash.Get[${iCounter}].Location}"]
			echo [${iCounter}] Obj_OgreIH:CCS["${Obj_Trash.Get[${iCounter}].Location}"]]
			wait 20
			while ${Actor[id,${ActorID}].Target(exists)} && ${Actor[id,${ActorID}].InCombatMode} && ${Actor[id,${ActorID}].Health} > ${Obj_Trash.Get[${iCounter}].HP}
			{
				if !${bBehind} && ${Actor[id,${ActorID}].Distance} < 10
				{
					wait 20
					bBehind:Set[TRUE]
					Obj_OgreIH:CCS_Actor_Behind["notfighter",${ActorID}]
				}
				wait 10
			}
			wait 100
		}

		call Obj_OgreUtilities.HandleWaitForCombat
		call Obj_OgreUtilities.WaitWhileGroupMembersDead

		if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
			return FALSE
		}
		return TRUE	

	}
}
objectdef Object_Named1Trash
{
	variable string Name
	variable point3f Location
	variable int HP

	/*
		1: Obj_Trash:Insert["an aqueous Luminary","3.610000,78.122375,26.150000",76]
		2: Obj_Trash:Insert["a frigid Luminary","-50.410000,78.122375,-17.910000",51]
		3: Obj_Trash:Insert["a sanguinated Luminary","3.520000,78.122375,-18.190001",26]
		4: Obj_Trash:Insert["a toxic Luminary","-49.950001,78.122375,26.059999",26]
	*/
	method Initialize(string _Name, point3f _Location, int _HP)
	{
		variable int iCounter
		variable point3f TrashSpot[4]
		TrashSpot[1]:Set[-59.064690,78.122375,28.060158]
		TrashSpot[2]:Set[-59.557861,78.122368,-18.862631]
		TrashSpot[3]:Set[12.867499,78.122375,-19.186750]
		TrashSpot[4]:Set[13.437325,78.122383,27.783100]

		This.Name:Set["${_Named}"]
		
		for ( iCounter:Set[1] ; ${iCounter} <= 4 ; iCounter:Inc )
		{
			if ${Math.Distance[${_Location},${TrashSpot[${iCounter}]}]} < 20
			{
				This.Location:Set[${TrashSpot[${iCounter}]}]
				break
			}
		}
		This.HP:Set[${_HP}]
	}
	
}
		