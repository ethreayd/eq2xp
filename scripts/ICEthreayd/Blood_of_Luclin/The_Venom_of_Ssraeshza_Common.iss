variable string sZoneShortName="exp16_dun_ssraeshza_mines"
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
        ;// Start coding!
        ;// _StartingPoint is how we keep track of what named we are on. You're free to use a different method if you prefer.
        ;// 0 = Get into zone.
        ;// 1-# are each named, in order
        ;// Then the last number is to zone out.

        ;// While you can do anything you want here, this will handle getting into any zone from beside the portal. If you'd like to customize it, you're free to do so!
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
				
		if ${_StartingPoint} == 1
		{
			call This.Named1 "Rhag'Sekez"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: Rhag'Sekez"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

        if ${_StartingPoint} == 2
		{
			call This.Named2 "Rhag'Voreth"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Rhag'Voreth"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

	if ${_StartingPoint} == 3
		{
			call This.Named3 "Arch Nemesis Rhag'Nazza"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: Arch Nemesis Rhag'Nazza"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
		
			;// Finish zone (zone out)
		if ${_StartingPoint} == 4
		{
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.NavToLoc "-31.056551,-126.562859,327.893005"
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
		Obj_OgreIH:SetCampSpot
		
		;//Run to Tunnel Door
        Obj_OgreIH:ChangeCampSpot["34.983471,-187.691391,250.968597"]
		wait 50
		call Obj_OgreIH.Select_Zone_Version "auto" "normal"
        Ob_AutoTarget:AddActor["a Ssraeshzian sentry",10,FALSE,FALSE]
        ;//Run out into zone
		Obj_OgreIH:ChangeCampSpot["34.398346,-188.301544,217.209549"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
        ;//Run right towards corner
		Obj_OgreIH:ChangeCampSpot["-24.539831,-188.297226,215.449402"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
        ;//Trash
		Obj_OgreIH:ChangeCampSpot["-25.010542,-188.297775,274.796326"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
        ;//Corner
		Obj_OgreIH:ChangeCampSpot["-25.360765,-188.296494,336.077667"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
        ;//Trash
		Obj_OgreIH:ChangeCampSpot["33.447620,-188.296921,335.889893"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
        ;//Corner
		Obj_OgreIH:ChangeCampSpot["95.607109,-188.295929,336.173157"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
        ;//Trash
		Obj_OgreIH:ChangeCampSpot["93.871658,-188.300171,275.907959"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50

        ;//Setup for named
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["95.149536,-188.256241,198.759964"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        Actor["${_NamedNPC}"]:DoTarget
        wait 15
        call Obj_OgreIH.KillAll "${_NamedNPC}" "-SetUpFor"
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
		Obj_OgreIH:ChangeCampSpot["111.074181,-188.257904,200.015778"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
		;//Trash
		Obj_OgreIH:ChangeCampSpot["110.420692,-188.259537,276.3210142"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
        ;//Looking for trash
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["112.786049,-188.253738,351.815857"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
        ;//Looking for trash
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-41.196751,-188.257950,351.647278"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
        ;//Trash
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-41.072170,-188.258286,275.767365"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
        ;//Move to Setup for Named
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-41.281807,-188.255356,352.819702"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
				
		;// Second Name 
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["10.217353,-188.258926,351.350739"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        Actor["${_NamedNPC}"]:DoTarget 
        wait 15
        call Obj_OgreIH.KillAll "${_NamedNPC}" "-SetUpFor"
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
		OgreBotAPI:ChangeOgreBotUIOption["all","checkbox_autotarget_outofcombatscanning",TRUE]
      	Ob_AutoTarget:AddActor["a travailing flood control engineer",1,FALSE,FALSE]
		OgreBotAPI:UseItem["all","Totem of the Otter"] 

        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-42.740723,-188.254166,352.511353"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
		Obj_OgreIH:ChangeCampSpot["-40.574631,-188.259491,242.409180"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50

		Obj_OgreIH:ChangeCampSpot["-43.578247,-188.252121,351.044037"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50
		
		;;Move to Swim up Point
		Obj_OgreIH:ChangeCampSpot["33.382915,-188.232956,349.528625"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 50

		;;Swim straight up to the top
	    Obj_OgreIH:LetsGo
		Obj_OgreIH:Set_NoMove
		oc !ci -FlyUp "igw:${Me.Name}"
		wait 60	
		oc !ci -FlyStop "${Me.Name}"
		wait 10
		oc !ci -FlyStop "igw:${Me.Name}"
		wait 5
		
		;;Swim straight out to set to Swim Up again
       	Obj_OgreIH:SetCampSpot
        call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["34.887550,-140.576370,318.687805"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 
		wait 50

		;;Swim straight up to same level as named
        Obj_OgreIH:LetsGo
		Obj_OgreIH:Set_NoMove
		oc !ci -FlyUp "igw:${Me.Name}"
		wait 80	
		oc !ci -FlyStop "${Me.Name}"
		wait 10
		oc !ci -FlyStop "igw:${Me.Name}"
		wait 5
		      
       	;// Last Name 
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		;//Swim to platform where named stands
		Obj_OgreIH:ChangeCampSpot["35.229057,-96.817757,274.223877"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        wait 10
		;//Swim back to spot before swimming to platform
        Obj_OgreIH:ChangeCampSpot["89.675713,-102.447060,330.063477"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        wait 10

		;//Swim back down to first stop point
        Obj_OgreIH:LetsGo
		Obj_OgreIH:Set_NoMove
		oc !ci -FlyDown "igw:${Me.Name}"
		wait 80	
		oc !ci -FlyStop "${Me.Name}"
		wait 10
		oc !ci -FlyStop "igw:${Me.Name}"
		wait 5

        ;//Swim short distance before final swim down to floor level
		Obj_OgreIH:SetCampSpot
		Obj_OgreIH:ChangeCampSpot["109.809219,-162.651825,351.154785"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10

        Obj_OgreIH:LetsGo
		Obj_OgreIH:Set_NoMove
		oc !ci -FlyDown "igw:${Me.Name}"
		wait 70	
		oc !ci -FlyStop "${Me.Name}"
		wait 10
		oc !ci -FlyStop "igw:${Me.Name}"
		wait 5

		;//Final swim down to floor level
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 10
		wait 10

        Actor["${_NamedNPC}"]:DoTarget 
        wait 15
        call Obj_OgreIH.KillAll "${_NamedNPC}" "-SetUpFor"
            wait 20
        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
            		
			return TRUE
	}		
}
