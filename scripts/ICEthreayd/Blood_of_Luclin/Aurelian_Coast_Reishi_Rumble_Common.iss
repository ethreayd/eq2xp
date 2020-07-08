;// Common to the zone category (IE: Aurelian Coast)
variable string sZoneShortName="exp16_dun_aurelian_coast_03"
variable string sZoneIn_ObjectName="zone_to_pof"

;// Need this include, it handles a lot of the variable creation.
#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

function main(int _StartingPoint=0)
{
	;// This creates all the required variables, and calls "RunInstances". 
	call function_Handle_Startup_Process "-NoAutoLoadMapOnZone"
}

;// This is optional. I like it so I can confirm when the file has been exited.
atom atexit()
{
	echo ${Time}: ${Script.Filename} done
}

;// This object definition must be exactly this name.
objectdef Object_Instance
{
    ;// This is our main function. The name must be exactly this.
	function:bool RunInstance(int _StartingPoint=0)
	{
        ;// Start coding!
        ;// _StartingPoint is how we keep track of what named we are on. You're free to use a different method if you prefer.
        ;// 0 = Get into zone.
        ;// 1-# are each named, in order
        ;// Then the last number is to zone out.

        ;// While you can do anything you want here, this will handle getting into any zone from the mission area. If you'd like to customize it, you're free to do so!
		if ${_StartingPoint} == 0
		{
			call Obj_OgreIH.ZoneNavigation.GetIntoZone "${sZoneName}"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone
				return FALSE
			}
			Ogre_Instance_Controller:ZoneSet
			call Obj_OgreIH.Set_VariousOptions
			call Obj_OgreIH.Set_PriestAscension FALSE
			
			Obj_OgreIH:Set_NoMove
			_StartingPoint:Inc
		}

        ;// Now it's your turn! Start coding. I've left in an example of a named to give you a starting point.
        if ${_StartingPoint} == 1
		{
			call This.Named1 "Nerobahan"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: Nerobahan"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

        if ${_StartingPoint} == 2
		{
			call This.Named2 "Ghest Roppep"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Ghest Roppep"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

	if ${_StartingPoint} == 3
		{
			call This.Named3 "Ropscion Mindeye"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3:  Ropscion Mindeye"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
			
		;// Finish zone (zone out)
		if ${_StartingPoint} == 4
		{
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.NavToLoc "492.167786,31.749466,592.345215"
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
    function:bool Named1(string _NamedNPC="Doesnotexist")
	{
		call Obj_OgreIH.Select_Zone_Version "auto" "normal"
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["547.946167,16.999928,490.733276"]
		Ob_AutoTarget:AddActor["an ancient grove tender",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an ancient sensate reishi",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an ancient firecap",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an ancient death cap",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an angry death cap",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an very angry death cap",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an ancient grove tender",1,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an ancient sensate reishi",1,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an ancient firecap",1,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an ancient death cap",1,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an angry death cap",1,FALSE,TRUE]
		Ob_AutoTarget:AddActor["an very angry death cap",1,FALSE,TRUE]
		
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["624.166931,18.380106,501.956146"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		;// First Named - Tank and Spank
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["634.345093,23.958851,580.736450"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget"
            wait 20
        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
        
        return TRUE
    }
    function:bool Named2(string _NamedNPC="Doesnotexist")
	{
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["602.908142,21.338831,469.219818"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		;// Trash-only ring event
		call Obj_OgreUtilities.PreCombatBuff 5
       	Obj_OgreIH:ChangeCampSpot["516.724121,18.271490,507.214905"]
        call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
        			
		call Obj_OgreIH.HandleAutoAggroRingEventUntilNamedSpawns "NPCNamedThatSpawnsAtTheEnd"
                
      	call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["448.808624,18.338243,534.820007"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["398.986694,20.539623,543.918762"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["398.986694,20.539623,543.918762"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		;// Tank and Spank
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["349.510742,44.296631,573.366028"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        call Obj_OgreIH.KillAll "${_NamedNPC}"
            wait 20
        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
        
        return TRUE
    }
    function:bool Named3(string _NamedNPC="Doesnotexist")
	{
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["456.234375,17.847664,536.895996"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		;// Trash-only ring event
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["468.912262,22.704491,564.792786"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		

		call Obj_OgreIH.HandleAutoAggroRingEventUntilNamedSpawns "NPCNamedThatSpawnsAtTheEnd"
		
		;// Tank and Spank
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["489.270294,31.663895,588.765930"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["457.170288,17.630421,539.179199"]
		wait 10		
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		
		Actor["${_NamedNPC}"]:DoTarget
        wait 30
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		call Obj_OgreUtilities.WaitWhileGroupMembersDead
				
        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		return TRUE
    }
	
}