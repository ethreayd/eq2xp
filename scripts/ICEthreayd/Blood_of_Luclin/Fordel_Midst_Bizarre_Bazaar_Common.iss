variable string sZoneShortName="exp16_dun_fordel_midst_01"

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

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
	
		OgreBotAPI:ChangeLootOptions["all","LeaderOnlyLoot"] 
		if ${_StartingPoint} == 0
		{
			
			call Obj_OgreIH.ZoneNavigation.GetIntoZone "${sZoneName}"
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
		
		; Talk to the fucking cat
		if ${_StartingPoint} == 1
		{
			;//call Obj_OgreIH.SkipPuzzles "Percy" "-274.100006,-1.755957,157.470001" 1
			call Obj_OgreUtilities.HandleWaitForCombat
			_StartingPoint:Inc
		}
		
		if ${_StartingPoint} == 2
		{
			call This.Named1 "Financier Fendilix"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#1: Financier Fendilix"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
		}

		if ${_StartingPoint} == 3
		{
			call This.Named2 "Mandee Quin"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#2: Mandee Quin"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
		}

		if ${_StartingPoint} == 4
		{
			call This.Named3 "Short Shift"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#3: Short Shift"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
		}
		if ${_StartingPoint} == 5
		{
			call This.Named4 "Trade Baroness Elsindir"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#4: Trade Baroness Elsindir"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
		}
		if ${_StartingPoint} == 6
		{
			call This.Named5 "Bazaar Baron Brixwald"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#5: Bazaar Baron Brixwald"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
		}

		;// Finish zone (zone out)
		if ${_StartingPoint} == 7
		{
			call Obj_OgreUtilities.NavToLoc "264.369415,-33.059879,-49.722061"
			call Obj_OgreUtilities.HandleWaitForGroupDistance 3
			call Obj_OgreIH.ZoneNavigation.ZoneOut
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZoneOut
				return FALSE
			}
			Obj_OgreIH:CancelGroupWaterBreathing
			_StartingPoint:Inc
		}
		return TRUE
	}
	
	function:bool Named1(string _NamedNPC="Doesnotexist")
	{
		echo Zone-In - Start move to main door to click for zone version.
		Obj_OgreIH:SetCampSpot
		wait 50
		Obj_OgreIH:ChangeCampSpot["-273.815369,-1.675182,192.437790"]
		wait 50
		call Obj_OgreIH.Select_Zone_Version "auto" "normal"
		wait 30
		
		echo Clicked door
		
		echo Move-In
		Obj_OgreIH:SetCampSpot
		wait 50
		Obj_OgreIH:ChangeCampSpot["-274.36,-1.76,157.14"]
		wait 50
		
		echo Move to the kitty
		call Obj_OgreIH.SkipPuzzles "Percy" "-274.100006,-1.755957,157.470001" 1
		wait 30

		Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-294.089539,-1.755957,139.12684"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		echo Made it to first campspot

		echo Made it to Archway
		;//Archway to Financier Fendilix
        call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-286.331757,-1.417957,76.446457"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
        
		echo Pulling Financier
        ;//Pre-Buff for Named - Financier Fendilix
        call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-273.340332,-1.685513,36.9385"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		Actor["${_NamedNPC}"]:DoTarget
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC "${_NamedNPC}"
		wait 10
		call Obj_OgreUtilities.WaitWhileGroupMembersDead

		if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
			return FALSE
		}
		
		return TRUE	
	}
	function Named2(string _NamedNPC)
	{
		variable string OtherNamedNPC="Mannee Quin"
		variable string ItemName="30 Grit Sand Rune"
		variable int iCounter

        ;//Back out towards 2nd Named
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-288.645447,-1.755957,94.275642"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["-213.808945,-2.258293,95.828323"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 50

		Echo Auto consuming 30 Grit Sane Rune

		call Obj_OgreUtilities.HandleWaitForCombat
		for ( iCounter:Set[1] ; ${iCounter} <= 3 ; iCounter:Inc )
		{
			if !${Me.Inventory["${ItemName}"].AutoConsumeOn}
			{
				Me.Inventory["${ItemName}"]:ToggleAutoConsume
				wait 50
				echo Using 30 Grit Sand Rune
			}
		}
		if !${Me.Inventory["${ItemName}"].AutoConsumeOn}
		{
			Obj_OgreIH:Message["Unable to get ${ItemName} to be auto consumed."]
			Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
			return FALSE
		}
		wait 100

        Obj_OgreIH:ChangeCampSpot["-163.574768,-1.501349,80.48461"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 50

		if !${Actor[exactname,"${_NamedNPC}"].ID(exists)}
			wait 50
			
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
			return TRUE
		}
		
        Echo Pulling Mannee
		;//Pull Spot for 2nd Named - Mannee Quin
        Obj_OgreIH:ChangeCampSpot["-121.541077,-1.499073,80.228882"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
       	
		if !${Actor[exactname,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
			return TRUE
		}
				
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 5
		Actor["${_NamedNPC}"]:DoTarget
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC "${_NamedNPC}"
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC "${OtherNamedNPC}"
		wait 10
		call Obj_OgreUtilities.WaitWhileGroupMembersDead

		if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
			return FALSE
		}
		if ${Me.Inventory["${ItemName}"].AutoConsumeOn}
		{
			Me.Inventory["${ItemName}"]:ToggleAutoConsume
			wait 50
		}
		OgreBotAPI:CancelMaintained["${ItemName}"]
		return TRUE	
	
		Echo Mann is no mas...moving on.
	}
		
	function Named3(string _NamedNPC)
	{
		
		variable string ItemName="Lucky Horseshoe"
		variable int iCounter
		
		
       Echo Moving to hallway towards 3rd named
	    ;//Path to 3rd Named
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-88.233543,-2.745953,103.861900"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["-90.142799,-1.553778,155.640823"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		Echo Casting Horseshoe SUPER early, for bitch ass groups...

			if ${Me.Inventory["${ItemName}"].AutoConsumeOn}
		{
			Me.Inventory["${ItemName}"]:ToggleAutoConsume
			wait 50
		}

		call Obj_OgreUtilities.PreCombatBuff 5
		wait 30
		for ( iCounter:Set[1] ; ${iCounter} <= 3 ; iCounter:Inc )
		{
			if ${Me.Inventory["${ItemName}"].TimeUntilReady} <= 0
			{
				Echo Using Lucky Horseshoe
				OgreBotAPI:UseItem["all","${ItemName}"]
				wait 50			
			}
		}

        Obj_OgreIH:ChangeCampSpot["-62.288876,-1.741144,156.561066"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 50

		
		echo Pulling Short Shift
		;//Pre-buff for 3rd Named 
		
        call Obj_OgreUtilities.PreCombatBuff 1
		Obj_OgreIH:ChangeCampSpot["-61.257793,-1.741144,192.500961"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 50
		
		
		Actor["${_NamedNPC}"]:DoTarget
		wait 60
		call Obj_OgreUtilities.HandleWaitForCombatWithNPC "${_NamedNPC}"
		wait 10
		call Obj_OgreUtilities.WaitWhileGroupMembersDead

		if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
			return FALSE
		}
		OgreBotAPI:CancelMaintained["${ItemName}"]
		return TRUE	
	}
	function Named4(string _NamedNPC)
	{
		variable string ItemName="Upgraded Lucky Horseshoe"
		variable string ItemNameGrit="30 Grit Sand Rune"
		variable int iCounter

		
	Echo Moving back out towards 4th named
	;//Path back out to 4rd Named
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-62.217632,-1.741144,156.890625"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["-90.089172,-1.553778,157.068863"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["-89.556183,-2.745953,111.264328"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		;//Pre-pull for 4th Named - Trade Baroness
        Obj_OgreIH:ChangeCampSpot["-55.175434,-1.493911,74.004089"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		Echo Pulling Trade Baroness
		
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-33.309261,-1.489189,60.046745"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10

		Actor["${_NamedNPC}"]:DoTarget
        wait 60
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		call Obj_OgreUtilities.WaitWhileGroupMembersDead

        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		echo ${_NamedNPC} done
		eq2execute summon
		wait 30
		call Obj_OgreIH.Get_Chest
		wait 30

        Echo Changing Loot Options to Free For All...hopefully.
        OgreBotAPI:ChangeLootOptions["all","FreeForAll"] 
		
		wait 30
		call Obj_OgreIH.Get_Chest
		wait 30
		oc !c -UplinkOptionChange All checkbox_settings_loot TOGGLE
		oc !c -ofol---
		oc !c -ofol---
		oc !c -ofol---
		wait 50
		oc !c -OgreFollow All ${Me.Name}
		oc !c -UplinkOptionChange All checkbox_settings_loot TOGGLE
		wait 30
		OgreBotAPI:CancelMaintained["${ItemName}"]
		return TRUE				
    }

function Named5(string _NamedNPC)
	{
		variable string ItemName="Upgraded Lucky Horseshoe"
		variable string ItemNameGrit="30 Grit Sand Rune"
		variable int iCounter
		
		Echo Changing Loot Options back to Leader Only
		OgreBotAPI:ChangeLootOptions["All","LeaderOnlyLoot"] 

    ;//Path to Final Named
        Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["27.276621,-1.755957,75.312019"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["96.609993,-1.755957,78.274368"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["109.157669,-1.755957,114.607239"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 30
        
		OgreBotAPI:UseItem_Relay["all","Spirit of the Cat"]
		
		wait 100

        Echo Use Spirit of the Cat to get pass ghosty body guard.

		;//Door - Need to use Spirit of Cat on everyone to get past...or COT to tank!
        Obj_OgreIH:ChangeCampSpot["147.210953,-1.508779,113.514732"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["148.251541,-1.508991,136.503937"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["189.765656,-0.825974,136.345062"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["190.055862,-0.825974,147.273544"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["219.334625,-0.830948,147.373886"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		 Obj_OgreIH:ChangeCampSpot["225.280624,-0.491777,125.967697"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10	

		
        Obj_OgreIH:ChangeCampSpot["301.147552,-0.491772,126.534737"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["308.453644,-0.830736,147.441193"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["326.936859,-0.830815,147.784348"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["327.868011,-0.830815,167.957916"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["274.971069,-20.134447,167.838089"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["275.145294,-33.035496,116.369537"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

        Obj_OgreIH:ChangeCampSpot["264.332001,-33.035496,116.274246"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10

		Echo First Campspot out of tunnel towards final named.
		
        Obj_OgreIH:ChangeCampSpot["257.115845,-33.059879,23.780746"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 50

		if !${Me.Inventory["${ItemName}"](exists)}
		{
			Obj_OgreIH:Message["Unable to find ${ItemName} in inventory."]
			
			return FALSE
		}
		for ( iCounter:Set[1] ; ${iCounter} <= 3 ; iCounter:Inc )
		{
			if ${Me.Inventory["${ItemName}"].TimeUntilReady} <= 0
			{
				OgreBotAPI:UseItem["all","${ItemName}"]
				wait 50
			}
		}

		for ( iCounter:Set[1] ; ${iCounter} <= 3 ; iCounter:Inc )
		{
			if !${Me.Inventory["${ItemNameGrit}"].AutoConsumeOn}
			{
				Me.Inventory["${ItemNameGrit}"]:ToggleAutoConsume
				wait 50
			}
		}
		if !${Me.Inventory["${ItemNameGrit}"].AutoConsumeOn}
		{
			Obj_OgreIH:Message["Unable to get ${ItemNameGrit} to be auto consumed."]
			
			return FALSE
		}

        Echo Pulling Final Named
		;//Pre=Pull spot for final Named
		Ob_AutoTarget:AddActor["Bazaar Baron Brixwald",0,FALSE,FALSE]
        Obj_OgreIH:ChangeCampSpot["258.774048,-33.059879,-19.956154"]
		wait 600
		do
		{
			call IsPresent "${_NamedNPC}" 5000
			target "${_NamedNPC}"
		}
		while (${Return} && !${Me.InCombatMode})
        if !${Actor[exactname,"${_NamedNPC}"].ID(exists)}
		{
			Obj_OgreIH:Message_NamedDoesNotExistSkipping["${_NamedNPC}"]
			return TRUE
		}
		
		call Obj_OgreUtilities.PreCombatBuff 5
		oc !c -AutoTarget_SetScanRadius ${Me.Name} 60
		Actor["${_NamedNPC}"]:DoTarget 
		wait 50
		call Obj_OgreUtilities.HandleWaitForCombat 
		wait 20
        call Obj_OgreUtilities.WaitWhileGroupMembersDead 

        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
        OgreBotAPI:CancelMaintained["${ItemName}"]
		return TRUE  
    }

}