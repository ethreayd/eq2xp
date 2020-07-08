variable string sZoneShortName="exp16_dun_sanctus_seru"

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

/*

*Notes 
-If autotarget is added for a fight, it is cleared after the fight
-After the Final Named, will clear checkbox for AutoTarget and Out of Combat Scanning for everyone

*Zone Details

-Move to starting NPC
-Try to Click Dialog or just wait

-Clear 4 mobs that range at start keeping you in combat

-Clear the quest mob at start for Signature Quest update

-Move to and clear trash of 1st Named : "Moggtu the Mad"
	*OgreBot will handle the /stand in heroic version when you get Feign Deathed

-Move to and activate 2nd Named : "Cerio Vallain"
	*Move behind is disabled for this fight to keep healers planted
	*Auto target added for the adds
	*Updated, will wait longer and do better at targeting the civilians to spawn the boss

-Move to portal back to start

-Move to 3rd Named area
-Clear trash around the 3rd Named area

-Move to and kill 3rd Named : "Raizyl Pajdu"
	*Will just pull named and campspot in the middle for now

-Move to and pull 4th Named : "Dichromanus"
	*Adds auto target for 2 adds.
	*Dont know the actual strat, so just ignore it.

-Move to portal back to start

-Move to and pull Final Named : "Lady Warglave"

-Move to and exit Zone

	
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

		
		if ${_StartingPoint} == 1
		{
			call This.Named1 "Moggtu the Mad"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#1: Moggtu the Mad"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
			;// Once this guy is dead, lets wait a short amount of time to move on
			wait 50
			;// 5 seconds be good? no idea.
		}

		if ${_StartingPoint} == 2
		{
			call This.Named2 "Cerio Vallain"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#2: Cerio Vallain"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

		if ${_StartingPoint} == 3
		{
			call This.Named3 "Raizyl Pajdu"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#3:  Raizyl Pajdu"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

		if ${_StartingPoint} == 4
		{
			call This.Named4 "Dichromanus"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#4: Dichromanus"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

		if ${_StartingPoint} == 5
		{
			call This.Named5 "Lady Warglave"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedZone["#5:  Lady Warglave"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			_StartingPoint:Inc
		}

		;// Finish zone (zone out)
		if ${_StartingPoint} == 6
		{
			Obj_OgreIH:ChangeOgreBotUIOption["checkbox_autotarget_enabled",FALSE]
			Obj_OgreIH:ChangeOgreBotUIOption["checkbox_autotarget_outofcombatscanning",FALSE]
			Obj_OgreIH:LetsGo
			call Obj_OgreUtilities.NavToLoc "-266.934357,90.157898,-0.063454"
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
		;// Echoing Current zone file version and last updated Date
		echo "Zone file last updated - 15 April 2020"
		Obj_OgreIH:SetCampSpot
		Obj_OgreIH:ChangeCampSpot["-380.435974,87.724243,0.252069"]
        call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 40
		echo "Clicking Barrier / Door and setting to Normal"

	  	call Obj_OgreIH.Select_Zone_Version "auto" "normal"
		
		echo "Should have clicked Normal"
		
        ;// Clearing Trash and Moving to 1st Named Location Left (South) Side
		echo "Starting movement through zone"
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-361.828613,89.628410,-0.161460"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 15
		wait 50
		oc !ci -Conversation_Bubble igzw:${Me.Name} 1 1
		wait 20
		call Obj_OgreUtilities.HandleWaitForCampSpot 100
		
		;// Kill the 4 stuipd rangers/mobs who keep fucking up my script
		echo "Killing these bitch ass ranged mobs messing up my shit"

		OgreBotAPI:ChangeOgreBotUIOption["all","checkbox_autotarget_outofcombatscanning",TRUE]
		Ob_AutoTarget:AddActor["an Echelon vigilant",95,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a Luminary ranger",95,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an Echelon vigilant",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a Luminary ranger",0,FALSE,FALSE]

		Obj_OgreIH:ChangeCampSpot["-363.745087,91.022255,27.764256"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
		
		echo "Waiting for stupid ranger to die"
		while ${Actor[exactname,"an Echelon vigilant"](exists)} && ${Actor[exactname,"an Echelon vigilant"].Distance} <=15
    		{
       			do
       			 	{
        		    waitframe
      			  	}
     		   while ${Actor[exactname,"an Echelon vigilant"].Distance} <=15
    		}

		echo "Ok it's dead moving to other side"
		Obj_OgreIH:ChangeCampSpot["-363.564392,91.022789,-28.652714"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
		echo "Waiting for stupid ranger to die"
		while ${Actor[exactname,"an Echelon vigilant"](exists)} && ${Actor[exactname,"an Echelon vigilant"].Distance} <=15
    		{
       			do
       			 	{
        		    waitframe
      			  	}
     		   while ${Actor[exactname,"an Echelon vigilant"].Distance} <=15
    		}

		echo "Ok it's dead moving back to middle"

		Obj_OgreIH:ChangeCampSpot["-362.825806,89.630829,0.114736"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
		wait 30

		echo "Clearing AutoTarget list"
		Ob_AutoTarget:Clear


		;//killing luminary for quest / not sure if required for zone
		echo "Moving to signature quest mob, then on to clearing trash."

		Obj_OgreIH:ChangeCampSpot["-301.491272,89.616943,31.195782"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 50
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-252.211029,89.616943,22.730114"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Ob_AutoTarget:AddActor["a Luminary bargainer",0,FALSE,FALSE]
		call Obj_OgreUtilities.HandleWaitForCombat
		Ob_AutoTarget:Clear

		;//clearing trash anywhere near named encounter prior to pull
		echo "Clearing trash around 1st Boss Moggtu the Mad "

		Obj_OgreIH:ChangeCampSpot["-322.086243,89.616943,31.585609"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 10
		Obj_OgreIH:ChangeCampSpot["-303.948822,87.651077,92.890800"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-287.152008,87.669197,158.932312"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-247.373215,87.652046,174.053146"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-280.943665,87.647102,207.013138"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-301.280029,87.657845,153.277817"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-331.968658,87.637527,120.754364"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat

		echo "Going up the ramp to kill a Luminary ranger and squad"
		
		Obj_OgreIH:ChangeCampSpot["-280.557281,87.638763,100.433037"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-267.796600,94.229034,94.573799"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-268.738342,94.605713,107.069763"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-265.294250,94.605713,114.556854"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		if ${Actor["a Luminary ranger"].ID(exists)} && ${Actor["a Luminary ranger"].Distance} < 5
   			Actor["a Luminary ranger"]:DoTarget
		wait 20


		;// Clear trash around named to make name come active
		echo "Jumpin off Airborne style and clearing 4 Luminarys around the boss to activate him"

		call Obj_OgreUtilities.PreCombatBuff 10
		Obj_OgreIH:ChangeCampSpot["-239.230225,87.675316,132.166870"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		if ${Actor["a Luminary ranger"].ID(exists)} && ${Actor["a Luminary ranger"].Distance} < 10
   			Actor["a Luminary ranger"]:DoTarget
		while ${Actor[exactname,"a Luminary ranger"](exists)} && ${Actor[exactname,"a Luminary ranger"].Distance} <=10
    		{
       			do
       			 	{
        		    waitframe
      			  	}
     		   while ${Actor[exactname,"a Luminary ranger"].Distance} <=10
    		}
		
		
		wait 10
		echo "rangers are dead, named incoming"
		;// First Named - Tank and Spank w/ Feigh Deaths
		echo "crouching to help with fear"		
		Obj_OgreIH:ChangeCampSpot["-242.819183,87.679855,141.184448"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Ob_AutoTarget:AddActor["Moggtu the Mad",0,FALSE,FALSE]
		wait 10
		oc !c -crouch igw:${Me.Name}
		echo "Starting OgreIH KillAll"
		call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget"
		wait 20
		
		Ob_AutoTarget:Clear
		echo "Moggtu the Mad is Dead, Moving On"
		oc !c -crouch igw:${Me.Name}
		echo "crouching Off, AutoTarget Cleared"
		
        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		
		return TRUE
    }

    function:bool Named2(string _NamedNPC="Doesnotexist")
	{
		;// Clearing Trash and Moving toward 2nd Named Location Left (South) Side
		echo "Clearing trash towards the 2nd Named"

		Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-268.206573,87.634201,214.572067"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 5

		Obj_OgreIH:ChangeCampSpot["-190.906448,81.863007,268.087189"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 15
		Obj_OgreIH:ChangeCampSpot["-115.490044,81.896439,312.338745"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 15
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 30

		;// Move to each "an affirmation seeker", click, kill and move to next
		echo "Clicking the affirmation seekers to activate Cero"

		Obj_OgreIH:ChangeCampSpot["-7.212032,87.651726,352.319580"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
		wait 20
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 20
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoTarget
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoubleClick
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 10
		Obj_OgreIH:ChangeCampSpot["-3.335655,87.650696,351.148315"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
		wait 10
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoTarget
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoubleClick
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["0.166662,87.650085,351.023010"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoTarget
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoubleClick
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["4.132788,87.646294,350.680756"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoTarget
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoubleClick
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["8.139157,87.642250,351.497559"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoTarget
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoubleClick
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["12.080881,87.638321,352.454681"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 20
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoTarget
		if ${Actor["an affirmation seeker"].ID(exists)} && ${Actor["an affirmation seeker"].Distance} < 2
   			Actor["an affirmation seeker"]:DoubleClick
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat

		;// buff and move to 2nd Name Cerio Vallain, DO not want move behind enabled. adds move around. forcing healers to run all over
		echo "Moving to Boss Cero Vallain, move behind is not enabled"

		call Obj_OgreUtilities.PreCombatBuff 10
		Obj_OgreIH:ChangeCampSpot["1.153478,88.578430,362.609924"]
		Ob_AutoTarget:AddActor["Spinto",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["Countertenor",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["Tenor",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["Soprano",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["bass",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["contralto",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["dramatic",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["baritone",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["Cerio Vallain",0,FALSE,FALSE]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 20
		echo "Starting OgreKillAll"
        call Obj_OgreIH.KillAll "${_NamedNPC}" 
			wait 20
			
		Ob_AutoTarget:Clear
		echo "Cero Vallain is dead, moving on."

        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
        return TRUE
    }

    function:bool Named3(string _NamedNPC="Doesnotexist")
	{

		;//Move from Cerio to the telporter back to entrance and wait for zoning
		echo "Moving from Cero to teleporter, will walk from 5 meters"
		Obj_OgreIH:ChangeCampSpot["26.518999,87.633652,341.144592"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		echo "Walking"
		oc !c -walk igw:${Me.Name}
		wait 10
		Obj_OgreIH:ChangeCampSpot["33.800087,88.048729,333.530975"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		Obj_OgreIH:SetCampSpot
		wait 30
		echo "Walking Turned Off"
		oc !c -walk igw:${Me.Name}
		wait 20

		;// Clearing Trash and Moving toward 3rd Named Location Right (North) Side
		echo "Clearing Trash North and moving toward 3rd Boss"

		Obj_OgreIH:SetCampSpot
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-325.031311,89.953430,-0.495674"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-315.000305,87.994934,-80.532188"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-300.175507,87.660339,-145.900040"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-301.011841,87.660339,-136.514099"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-255.816116,87.660339,-191.192215"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombat
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		Obj_OgreIH:ChangeCampSpot["-223.444305,87.660339,-199.461182"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombat
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10

		;// clearing trash around 3rd Name
		echo "Clearing trash around boss encounter area"

		Obj_OgreIH:ChangeCampSpot["-185.787476,88.218750,-209.601791"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 20
		call Obj_OgreUtilities.HandleWaitForCombat
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-142.595474,88.216125,-263.502319"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-109.176270,88.216125,-278.236206"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-40.012512,88.285889,-278.290894"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-34.667488,87.659805,-319.527924"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-59.123989,88.865112,-355.847656"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 20
		echo "Waiting for Raizyl Pajdu to move away from the trash while clearing trash"
		while ${Actor[exactname,"Raizyl Pajdu"](exists)} && ${Actor[exactname,"Raizyl Pajdu"].Distance} <=50
    		{
       			do
       			 	{
        		    waitframe
      			  	}
     		   while ${Actor[exactname,"Raizyl Pajdu"].Distance} <=50
    		}

		echo "Ok shes away moving on"

		call Obj_OgreUtilities.PreCombatBuff 5
		wait 10
		Obj_OgreIH:ChangeCampSpot["-90.855553,81.875420,-334.050934"]
		if ${Actor["a Luminary mage apprentice"].ID(exists)} && ${Actor["a Luminary mage apprentice"].Distance} < 20
   			Actor["a Luminary mage apprentice"]:DoTarget
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-42.831295,87.661995,-347.382843"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 20
		Obj_OgreIH:ChangeCampSpot["-42.790356,88.285889,-277.833801"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 20
		Obj_OgreIH:ChangeCampSpot["-115.030563,88.216125,-271.864594"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		Obj_OgreIH:ChangeCampSpot["-146.439041,88.216125,-261.679688"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		Obj_OgreIH:ChangeCampSpot["-167.229477,88.659302,-267.457520"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10

		echo "Waiting for Raizyl Pajdu to move away from the trash while clearing trash"
		while ${Actor[exactname,"Raizyl Pajdu"](exists)} && ${Actor[exactname,"Raizyl Pajdu"].Distance} <=50
    		{
       			do
       			 	{
        		    waitframe
      			  	}
     		   while ${Actor[exactname,"Raizyl Pajdu"].Distance} <=50
    		}
		echo "Ok shes away moving on"

		Obj_OgreIH:ChangeCampSpot["-244.160141,87.472099,-252.421295"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 20

		;// Pull Named and CS in center
		echo "Pulling boss to center, camping, letting her come back to us"
		call Obj_OgreUtilities.PreCombatBuff 15
		Obj_OgreIH:ChangeCampSpot["-153.490753,81.881645,-306.756165"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
        Ob_AutoTarget:AddActor["Raizyl Pajdu",0,FALSE,FALSE]
		call Obj_OgreIH.KillAll "${_NamedNPC}" 
			wait 20
			
		Ob_AutoTarget:Clear
		echo "Raizyl Pajdu is dead, moving on"

        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }

        return TRUE
    }

	function:bool Named4(string _NamedNPC="Doesnotexist")
	{

		;//Move from wherever chest was back to middle
		Obj_OgreIH:ChangeCampSpot["-153.490753,81.881645,-306.756165"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		
		;//Move to 4th named platform
		echo "Moving to 4th boss platform"

		Obj_OgreIH:ChangeCampSpot["-55.205299,87.636909,-345.162384"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10

		;// Move around to Pull Spot
		echo "Moving around to west side to prepare for the aggros"

		Obj_OgreIH:ChangeCampSpot["-39.449139,87.642860,-294.763000"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		
		;// Pull 4th Named Dichromanus, joust to him and to the Tank Spot
		echo "Pulling to the cubby for campspot"

		call Obj_OgreUtilities.PreCombatBuff 10
		Obj_OgreIH:ChangeCampSpot["-16.071371,87.677261,-319.162720"]
		Ob_AutoTarget:AddActor["a prismanima",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["prismatic cluster",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["Dichromanus",0,FALSE,FALSE]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-1.805830,87.648346,-279.755432"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		echo "Starting OgreKillAll"
        call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget"
			wait 20
			
		Ob_AutoTarget:Clear
		echo "Dichromanus is dead, moving on."

        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }

        return TRUE
    }

	function:bool Named5(string _NamedNPC="Doesnotexist")
	{

		;//Move from Dichromanus to the telporter back to entrance and wait for zoning
		echo "moving to the teleporter, will walk from 5 meters"

		Obj_OgreIH:ChangeCampSpot["-39.522011,87.664764,-340.587128"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		echo "Walking"
		oc !c -walk igw:${Me.Name}
		wait 10
		Obj_OgreIH:ChangeCampSpot["-47.105011,88.068733,-352.400208"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		Obj_OgreIH:SetCampSpot
		wait 30
		echo "Walking Turned Off"
		oc !c -walk igw:${Me.Name}
		wait 20
		
		;// Pull 5th Named 
		echo "Moving to final boss camp spot"

		call Obj_OgreUtilities.PreCombatBuff 10
		Obj_OgreIH:ChangeCampSpot["-270.024353,89.616943,25.850716"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Ob_AutoTarget:AddActor["Lady Warglave",98,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a Divinion Knight",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["Lady Warglave",0,FALSE,FALSE]
		wait 40
		echo "Starting OgreKillAll"
        call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget"
			wait 20
			
		Ob_AutoTarget:Clear
		echo "Lady Warglave is dead, moving on"

        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }

        return TRUE
    }
}