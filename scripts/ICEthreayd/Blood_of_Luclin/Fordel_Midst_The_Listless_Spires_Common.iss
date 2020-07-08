variable string sZoneShortName="exp16_dun_fordel_midst"
;// variable string sZoneIn_ObjectName="zone_to_pow"

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

/*
	clear trash:
		a resurgent invader
		a scorched terrortusk
		a merciless raider
		a parched warboar

	After all trash is dead, we may need to click/hail these guys:
		a frightened spirit

	first named: Old Witherby

	Second named: War Master Ryzon

	Trash of 3rd named: a fiery wraith
	
	Third named: Fire Monger Baltar

*/

function main(int _StartingPoint=0)
{
	call function_Handle_Startup_Process "-NoAutoLoadMapOnZone"
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
		call This.Named1 "Old Witherby"
			
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#1: Old Witherby"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chestw
			
			_StartingPoint:Inc
		}

		if ${_StartingPoint} == 2
		{
			call This.Named2 "War Master Ryzon"
			
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#2: War Master Ryzon"]
				return FALSE
			}
			
			call Obj_OgreIH.Get_Chestw
			
			_StartingPoint:Inc
		}

		if ${_StartingPoint} == 3
		{
			call This.Named3 "Fire Monger Baltar"
			; call Obj_OgreUtilities.PreCombatBuff 5
			; call Obj_OgreIH.KeepInfrontBehindOnNPC "Fire Monger Baltar" 1
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#3: Fire Monger Baltar"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chestw
			
			_StartingPoint:Inc
		}

		;// Finish zone (zone out)
        if ${_StartingPoint} == 4
        {
            Obj_OgreIH:LetsGo
            call Obj_OgreUtilities.NavToLoc "274.537659,-36.034050,722.970398"
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
		
		Obj_OgreIH:ChangeCampSpot["295.631836,-36.111881,918.614380"]
		wait 10
		call Obj_OgreIH.Select_Zone_Version "auto" "normal"
		Obj_OgreIH:ChangeCampSpot["287.307434,-36.132389,885.043823"]
		OgreBotAPI:ChangeOgreBotUIOption["all","checkbox_autotarget_outofcombatscanning",TRUE]
		oc !c -AutoTarget_SetScanRadius ${Me.Name} 30
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		Ob_AutoTarget:AddActor["a parched warboar",1,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a resurgent invader",1,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a merciless raider",1,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a scorched terrortusk",1,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an angry death cap",50,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an very angry death cap",50,FALSE,FALSE]
		;// Start Trash Clear Routine - Right Side
		Obj_OgreIH:ChangeCampSpot["257.009033,-36.151951,885.587585"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:Actor_Click[60815]
		Obj_OgreIH:ChangeCampSpot["260.453674,-36.122105,856.851624"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["207.719757,-36.144657,865.282166"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["205.261276,-36.151951,830.808533"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["182.337219,-36.151955,846.133118"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["192.728577,-36.122105,821.176392"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["169.373413,-36.151951,824.214966"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["175.012283,-36.122105,811.248047"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["159.827148,-36.151951,808.481445"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		;; Move to Left Side Trash Clear
		Obj_OgreIH:ChangeCampSpot["303.275970,-36.010258,867.169373"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["303.053558,-36.122105,844.119934"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["355.817871,-36.144657,837.198181"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["340.655273,-36.144657,819.679138"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["323.944275,-36.148300,815.320496"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["330.430328,-36.122105,784.800110"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["375.233337,-36.151951,777.321533"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["370.182465,-36.151955,738.336975"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["324.837280,-36.122105,746.852905"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["324.824036,-36.145329,725.672791"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["341.859955,-36.151947,724.111145"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["356.574982,-36.151951,717.231995"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		;// Move back near to Zone-In for First Named Pull Check Named code for non-tank solos
		Obj_OgreIH:ChangeCampSpot["292.026672,-35.975681,882.682129"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["215.033600,-36.144852,849.523926"]
		wait 10		
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
		Obj_OgreIH:ChangeCampSpot["311.589111,-36.122105,851.180542"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["338.161499,-36.151951,798.166321"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		
		;// Up the ramp towards 2nd named
		Obj_OgreIH:ChangeCampSpot["290.709564,-27.929811,778.019287"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		
		;// 2nd Named - Tank and Spank
		Obj_OgreIH:ChangeCampSpot["241.892975,-27.755915,766.904724"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		
		wait 10
		call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget"
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
		Obj_OgreIH:ChangeCampSpot["247.994644,-27.775715,779.014954"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["180.164581,-35.983883,763.035522"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		
		Obj_OgreIH:ChangeCampSpot["257.798065,-36.151951,672.452881"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		
		;// Last Named - Tank and Spank - Edit/remove keep behind for solos
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["304.475677,-36.144657,696.705627"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget"
            wait 20
        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		return TRUE
	}
}



