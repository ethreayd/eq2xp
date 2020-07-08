;// Common to the zone category (IE: Aurelian Coast)
variable string sZoneShortName="exp16_dun_aurelian_coast_01"
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
			call Obj_OgreIH.Set_PriestAscension TRUE
			
			Obj_OgreIH:Set_NoMove
			_StartingPoint:Inc
		}

        ;// Now it's your turn! Start coding. I've left in an example of a named to give you a starting point.
        if ${_StartingPoint} == 1
		{
			call This.Named1 "Ercel Bloodpaw"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#1: Ercel Bloodpaw"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

        if ${_StartingPoint} == 2
		{
			call This.Named2 "Grugnop, the Guard"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Grugnop, the Guard"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

	if ${_StartingPoint} == 3
		{
			call This.Named3 "Grrrunk the Trunk"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3: Grrrunk the Trunk"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}
		
	if ${_StartingPoint} == 4
		{
			call This.Named4 "Ryryrd of the Wind"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#4: Ryryrd of the Wind"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

	if ${_StartingPoint} == 5
		{
			call This.Named5 "Mrokor, the Smartist"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#5: Mrokor, the Smartist"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

		;// Finish zone (zone out)
		if ${_StartingPoint} == 6
		{
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.NavToLoc "-133.708755,81.913910,-687.281189"
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
		Obj_OgreIH:ChangeCampSpot["195.433395,61.918888,-290.2803"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Ob_AutoTarget:AddActor["a Sambata Shaman",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a Sambata gatherer",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a Sambata wolf",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["a Sambata Firekeeper",50,FALSE,TRUE]
		Ob_AutoTarget:AddActor["Mrokor, the Smartist",10,FALSE,TRUE]
		

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["181.352219,62.199009,-302.860992"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["130.121429,61.379818,-350.704712"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["94.638046,66.542305,-304.291931"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		
		;// First Named
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["98.557785,74.816551,-272.262115"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
        call Obj_OgreIH.KillAll "${_NamedNPC}"
            wait 20
        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		Obj_OgreIH:LetsGo
       
        return TRUE
    }
    function:bool Named2(string _NamedNPC="Doesnotexist")
	{
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["97.622192,61.363514,-366.404816"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["63.826267,63.303528,-392.340912"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		;// Second Named - Campspots group, wedges tank into rocks and camps.
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["19.089827,72.086731,-424.005157"]
		wait 5
		Ogre_CampSpot:Set_CCS[12.505716,75.479492,-426.626892]
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
    function:bool Named3(string _NamedNPC="Doesnotexist")
	{
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["26.399551,71.152130,-426.463196"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-3.012671,79.162193,-469.620697"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["16.218868,81.231766,-503.722198"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		
		Obj_OgreIH:ChangeCampSpot["-2.935099,87.790733,-524.283203"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 5
		call Obj_OgreUtilities.HandleWaitForCombat
 
		
		Obj_OgreIH:ChangeCampSpot["-8.895545,89.331230,-589.265808"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 5
		call Obj_OgreUtilities.HandleWaitForCombat

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["9.693727,89.057007,-596.7548831"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		;// 3rd Named - Tank and Spank
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["57.098713,78.080307,-573.159729"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        call Obj_OgreIH.KillAll "${_NamedNPC}"
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
		Obj_OgreIH:ChangeCampSpot["47,79,-582"]
		wait 10
		Obj_OgreIH:ChangeCampSpot["26,84,-585"]
		wait 10
		Obj_OgreIH:ChangeCampSpot["11.821312,88.725143,-596.009155"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["3.336112,89.269455,-612.548950"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		;// Fourth Name - Tank and Spank
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-21.570856,88.191719,-625.953308"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        call Obj_OgreIH.KillAll "${_NamedNPC}"
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
		Obj_OgreIH:ChangeCampSpot["-35.199928,87.782608,-642.593689"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-58.549568,81.836006,-705.008484"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		 
		;// Final Named - Kill Priest First
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-117.465271,81.851410,-684.434814"]
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
}