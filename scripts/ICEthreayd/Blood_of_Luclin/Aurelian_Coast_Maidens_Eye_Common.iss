;// Common to the zone category (IE: Aurelian Coast)
variable string sZoneShortName="exp16_dun_aurelian_coast_02"
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

        ;// Now it's your turn! Start coding. I've left in an example of a named to give you a starting point.
        if ${_StartingPoint} == 1
		{
			call This.Named1 "The Drudge Lord"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: The Drudge Lord"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

        if ${_StartingPoint} == 2
		{
			call This.Named2 "Xylox the Poisonous"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Xylox the Poisonous"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

	if ${_StartingPoint} == 3
		{
			call This.Named3 "Shadowed Abomination"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: Shadowed Abomination"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
		
	if ${_StartingPoint} == 4
		{
			call This.Named4 "Va Dyn Kar"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#4: Va Dyn Kar"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

	if ${_StartingPoint} == 5
		{
			call This.Named5 "The Shadow Overlord"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#5: The Shadow Overlord"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

		;// Finish zone (zone out)
		if ${_StartingPoint} == 6
		{
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.NavToLoc "-665.449280,79.212479,102.971169"
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
		Obj_OgreIH:ChangeCampSpot["-216.387192,4.823649,-15.865485"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Ob_AutoTarget:AddActor["a rotting drudge",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a crumbling drudge",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a reanimated drudge",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a skeletal drudge",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a shadowed behemonth",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a dread horror",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a dread stealer",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a thought stealer",50,FALSE,TRUE]
		

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-304.638550,2.627060,-171.896332"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		;// First Named - Tank and Spank
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-304.167450,3.726451,-209.018753"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		
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
		Obj_OgreIH:ChangeCampSpot["-413.612305,24.420992,-234.522476"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		
		Obj_OgreIH:ChangeCampSpot["-476.566711,34.740307,-217.898682"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-487.882965,30.628912,-157.667679"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
				
		;// Second Name - Coded / Joust Nox Shield
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-502.002899,31.649399,-144.407089"]
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
		Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-560.111084,48.084572,-67.116600"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-552.482788,58.803288,-20.962948"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-566.919006,60.112186,24.480129"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 5
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
 			
		;// Third Named - Tank and Spank - Add group to move behind here
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-553.538879,60.278503,46.366093`"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget"
            wait 20
        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		Obj_OgreIH:LetsGo
               				        
		return TRUE
    }
	function:bool Named4(string _NamedNPC="Doesnotexist")
	{
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-566.064514,59.613171,6.750818"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		Obj_OgreIH:ChangeCampSpot["-558.887939,50.948448,-53.521996"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-636.937317,52.726963,-59.022331"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-671.856628,58.406296,-100.206078"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat 
		wait 10

		;// Fourth Named - Tank and Spank
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-686.024414,59.163570,-129.155594"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget"
            wait 20
        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		Obj_OgreIH:LetsGo
       
        return TRUE
    }
	function:bool Named5(string _NamedNPC="Doesnotexist")
	{
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-631.104797,53.588326,-46.139359"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-672.153870,73.658836,42.150532"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		 
		;// Final Named - Ogre Coded
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-673.228882,77.740242,80.925850"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        Actor["${_NamedNPC}"]:DoTarget
        wait 15
        ; call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget" "-SetUpFor"
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