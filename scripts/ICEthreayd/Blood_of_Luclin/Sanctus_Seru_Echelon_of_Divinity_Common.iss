variable string sZoneShortName="exp16_dun_sanctus_seru_01"

#include "${LavishScript.HomeDirectory}/Scripts/EQ2OgreBot/InstanceController/Ogre_Instance_Include.iss"

/*

*Notes 
-If autotarget is added for a fight, it is cleared after the fight
-After the Final Named, will clear checkbox for AutoTarget and Out of Combat Scanning for everyone

*Zone Details

*Notes, 
fix golem pull before last named room.  wait longer for them to spawn.
add a wait for combat, after the wait, before moving to next campspot
looks like balistix got stuck on unhylla hail chat box
move the knight down the auto target list to the bottom
longer wait tim efor undyhilla npc spawn
add echo for wait times on undylla

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
			call This.Named1 "Divine Prophet Buffo II"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#1: Divine Prophet Buffo II"]
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
			call This.Named2 "Grand Cruciator Typhenon"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#2: Grand Cruciator Typhenon"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
			;// Once this guy is dead, lets wait a short amount of time to move on
			wait 50
			;// 5 seconds be good? no idea.
		}

		if ${_StartingPoint} == 3
		{
			call This.Named3 "Unhilynd"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#3: Unhilynd"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
			;// Once this guy is dead, lets wait a short amount of time to move on
			wait 50
			;// 5 seconds be good? no idea.
		}

		if ${_StartingPoint} == 4
		{
			call This.Named4 "Prysmerah, Arx Patrona"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#4: Prysmerah, Arx Patrona"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
			;// Once this guy is dead, lets wait a short amount of time to move on
			wait 50
			;// 5 seconds be good? no idea.
		}

		if ${_StartingPoint} == 5
		{
			call This.Named5 "Lord Triskian Seru"
			if !${Return}
			{
				Obj_OgreIH:Message_FailedNamed["#5: Lord Triskian Seru"]
				return FALSE
			}
			call Obj_OgreIH.Get_Chest
			
			_StartingPoint:Inc
			;// Once this guy is dead, lets wait a short amount of time to move on
			wait 50
			;// 5 seconds be good? no idea.
		}


		
		;// Finish zone (zone out)
		if ${_StartingPoint} == 6
		{
			Ob_AutoTarget:Clear
			Obj_OgreIH:ChangeOgreBotUIOption["checkbox_autotarget_enabled",FALSE]
			Obj_OgreIH:ChangeOgreBotUIOption["checkbox_autotarget_outofcombatscanning",FALSE]
			Obj_OgreIH:LetsGo
			;// Fix this Before Publishing!!
			call Obj_OgreUtilities.NavToLoc "50.289906,77.969238,4.406385" 
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
		Obj_OgreIH:ChangeCampSpot["8.043051,180.673828,187.832993"]
        call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 40
		echo "Clicking Barrier / Door and setting to Normal"

	  	call Obj_OgreIH.Select_Zone_Version "auto" "normal"
		
		echo "Should have clicked Normal"
		
        ;// Clearing any leftover / bugged auto target lists
		;// Setting scan radius to 30 for this zone
		echo "Clearing Auto Target"		
		 
		Ob_AutoTarget:Clear
		echo "Adding AutoTarget for trash to speed things up, will clear prior to Name 1"
		
		Ob_AutoTarget:AddActor["an upper Echelon guard",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an Echelon vigilant",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a Luminary arbiter",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an Echelon knight-crusader",0,FALSE,FALSE]


		;// Clearing Trash and Moving to 1st Named Location 
		echo "Starting movement through zone"
		call Obj_OgreUtilities.PreCombatBuff 10
		Obj_OgreIH:ChangeCampSpot["7.697651,179.857986,202.712219"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-33.271263,179.785461,209.596176"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-85.808586,175.677063,195.918304"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-127.759094,175.749557,208.296555"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-144.992050,175.680481,204.367874"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-155.957367,175.677795,174.267853"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-142.931854,175.686386,147.613785"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat

		;// Pulling the Trash around the named first, for weaker groups
		;// Clearing AutoTarget before pull
		echo "AutoTarget Cleared"
		Ob_AutoTarget:Clear
		echo "Pulling trash back from Named prior to pull"
		Ogre_CampSpot:Set_CCS[-118.446136,175.724716,163.876282]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Ogre_CampSpot:Set_CCS[-142.931854,175.686386,147.613785]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		call Obj_OgreUtilities.PreCombatBuff 10
		
		;// Moving to 1st Named cs
		echo "Moving to  Divine Prophet Buffo II "
		Obj_OgreIH:ChangeCampSpot["-113.755775,176.016907,157.429138"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		;// Adding named and the healing add to AutoTarget
		echo "Adding a Luminary arbiter and Buffo to AutoTarget"
		Ob_AutoTarget:AddActor["a Luminary arbiter",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["Divine Prophet Buffo II",0,FALSE,FALSE]
		wait 20
		;// Crouching for Fear
		echo "Crouching to mitigate fearing"
		oc !c -crouch igw:${Me.Name}
		wait 50
		echo "Starting OgreIH KillAll - MoveBehind is not ON to keep healers planted"
		call Obj_OgreIH.KillAll "${_NamedNPC}"
		wait 20
		;// Uncrouching
		echo "Uncrouching"
		oc !c -crouch igw:${Me.Name}
		
		echo "AutoTarget Clear"
		Ob_AutoTarget:Clear
		echo "Divine Prophet Buffo II is dead, Moving On"
		echo "AutoTarget Clear"

        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		
		return TRUE
    }

	function:bool Named2(string _NamedNPC="Doesnotexist")
	{   

		;// Adding trash auto target list back
		;// Temporary setting scan radius to 30
		oc !c -AutoTarget_SetScanRadius ${Me.Name} 25 
		echo "Temporarily putting scan radius to 25"
		echo "Adding AutoTarget for trash to speed things up, will clear prior to Name 2"
		Ob_AutoTarget:AddActor["a Luminary arbiter",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an upper Echelon guard",0,FALSE,FALSE]		
		Ob_AutoTarget:AddActor["an Echelon vigilant",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a Luminary interceder",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an Encholon lanista",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a Luminary recruit",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an Echelon knight-crusader",0,FALSE,FALSE]

		;// Starting Movement toward 2nd Name
		Obj_OgreIH:ChangeCampSpot["-113.755775,176.016907,157.429138"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10

		call Obj_OgreUtilities.PreCombatBuff 10
		Obj_OgreIH:ChangeCampSpot["-170.289398,179.860245,134.133575"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-201.258240,180.170944,64.133812"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-200.284576,179.807556,-53.438900"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-200.284576,179.807556,-53.438900"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-166.499283,179.831985,-130.858292"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		;// Clearing Trash for 3rd Named along the way
		echo "Clearing the trash for the 3rd Named along the way"
		Obj_OgreIH:ChangeCampSpot["-125.011894,175.684128,-143.568176"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-142.320480,175.782608,-178.918427"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-122.553596,175.758423,-196.802628"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-95.692703,175.688660,-165.738876"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-53.717079,179.793091,-190.953552"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		echo "Pulling trash back from Named prior to pull"
		Ogre_CampSpot:Set_CCS[-54.311707,179.789291,-210.377777]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Ogre_CampSpot:Set_CCS[-53.717079,179.793091,-190.953552]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-41.991882,179.789413,-201.097702"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		;// Clearing trash from named camp spot
		;// Waiting for named to be away
		echo "Pulling Trash from named CampSpot"
		echo "Waiting for Grand Cruciator Typhenon to move away while clearing trash"
		while ${Actor[exactname,"Grand Cruciator Typhenon"](exists)} && ${Actor[exactname,"Grand Cruciator Typhenon"].Distance} <=50
    		{
       			do
       			 	{
        		    waitframe
      			  	}
     		   while ${Actor[exactname,"Grand Cruciator Typhenon"].Distance} <=50
    		}

		echo "Ok Grand Cruciator Typhenon away moving on"
		echo "Pulling trash back from Named prior to pull"
		Ogre_CampSpot:Set_CCS[-32.880627,179.783218,-218.199417]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Ogre_CampSpot:Set_CCS[-41.991882,179.789413,-201.097702]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		;// Clear Auto Target Before MOving
		oc !c -AutoTarget_SetScanRadius ${Me.Name} 20
		echo "AutoTarget Clear"
		Ob_AutoTarget:Clear
		;// Moving to CampSpot
		echo "Moving To CampSpot for Named"
		Obj_OgreIH:ChangeCampSpot["-32.108616,179.782028,-223.709976"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		;// Adding Shield and Named to AutoTarget
		echo " Will pull Boss to wall, target adds and shield as they come."
		Ob_AutoTarget:AddActor["Typhenon's Shield Wall",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["Grand Cruciator Typhenon",0,FALSE,FALSE]
		while ${Actor[exactname,"Grand Cruciator Typhenon"](exists)} && ${Actor[exactname,"Grand Cruciator Typhenon"].Distance} >=10
    		{
       			do
       			 	{
        		    waitframe
      			  	}
     		   while ${Actor[exactname,"Grand Cruciator Typhenon"].Distance} >=10
    		}
		wait 10
		Ogre_CampSpot:Set_CCS[-32.704807,179.780136,-232.325836]
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 50

		echo "AutoTarget Clear"
		Ob_AutoTarget:Clear
		echo " Grand Cruciator Typhenon is dead, Moving On"
		echo "Should have Horn of the Fallen in your Bag"

        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		
		return TRUE
    }

	function:bool Named3(string _NamedNPC="Doesnotexist")
	{
		;// Starting movement to 3rd Boss
		Obj_OgreIH:ChangeCampSpot["-123.584366,175.679749,-175.847290"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		Obj_OgreIH:ChangeCampSpot["-143.369217,178.783386,-202.211212"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		;// Using the Horn to bring the Angel of Death
		echo "Using the Horn of the Fallen"
		Obj_OgreIH:Use_Item["Horn of the Fallen"]

		echo "Used the Horn, waiting for them to fly down"

		;// Targeting, Hailing, and clicking option 1
		;// Will currently ignore the barrage aspect, will add adds to auto target, and put tank in a cubby.
		echo "Targeting, Hailing, Selecting Option 1, currently will joust back, and ignore the airborne barrage"
		call Obj_OgreIH.NamedSpawnWait "Unhilynd" 30 "NoKill NPC"
		while ${Actor[exactname,"Unhilynd"](exists)} && ${Actor[exactname,"Unhilynd"].Distance} >=5
    		{
       			do
       			 	{
        		    waitframe
      			  	}
     		   while ${Actor[exactname,"Unhilynd"].Distance} >=5
    		}
		wait 60
		if ${Actor["Unhilynd"].ID(exists)} && ${Actor["Unhilynd"].Distance} < 10
   			Actor["Unhilynd"]:DoTarget
		if ${Actor["Unhilynd"].ID(exists)} && ${Actor["Unhilynd"].Distance} < 10
   			Actor["Unhilynd"]:DoubleClick
		wait 50
		oc !c -Conversation_Bubble igzw:${Me.Name} 1
		wait 30
		;// Clicked bubble, jousting to camp
		echo "Clicked Bubble, Jousting to Campspot"
		Obj_OgreIH:ChangeCampSpot["-143.261963,175.682434,-168.416718"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		echo "Waiting for Her to come active"
		call Obj_OgreIH.NamedSpawnWait "Unhilynd" 30 "NamedNPC"
		wait 10
		;// Named is killing mobs, then becoming active
		echo "Named is killing friends and becoming active"
		call Obj_OgreUtilities.PreCombatBuff 10
		Ob_AutoTarget:AddActor["a warrior of the fallen",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["Unhilynd",0,FALSE,FALSE]

		;// call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget" "-SetUpFor"
		echo "Named is coming, Keeping group behind and doing a -SetUpFor"
		call Obj_OgreIH.KillAll "${_NamedNPC}" "-SetUpFor"
				
		echo "AutoTarget Clear"
		Ob_AutoTarget:Clear
		echo " Unhilynd is dead, Moving On"

        if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		
		return TRUE
    }

	function:bool Named4(string _NamedNPC="Doesnotexist")
	{
		;// Adding trash auto target list back
		
		echo "Adding AutoTarget for trash to speed things up, will clear prior to Name 2"
		Ob_AutoTarget:AddActor["a Luminary arbiter",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an upper Echelon guard",0,FALSE,FALSE]		
		Ob_AutoTarget:AddActor["an Echelon vigilant",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a Luminary interceder",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an Encholon lanista",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a Luminary recruit",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["an Echelon knight-crusader",0,FALSE,FALSE]
		
		;// Starting movement to 4th Boss
		call Obj_OgreUtilities.PreCombatBuff 10
		Obj_OgreIH:ChangeCampSpot["-214.349304,179.843933,-95.848595"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		Obj_OgreIH:ChangeCampSpot["-196.470795,183.220154,-0.918327"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 20
		;// CLicking Door
		echo "Clicking Door to spawn 4th Boss"
		if ${Actor[exactname,"Door to Arx Seru"].Distance} <= 7 && !${Me.InCombat}
    		{
        		Actor[${Actor[exactname,"Door to Arx Seru"].ID}]:DoubleClick
    		}
		wait 20
		Obj_OgreIH:ChangeCampSpot["-198.925751,183.220154,4.496176"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 30
		;// Pre Buffing, Pulling with the Tank
		echo "Prebuffing and Pulling Boss with the tank back to the Door"
		call Obj_OgreUtilities.PreCombatBuff 20
		oc !c -Cast ${Me.Name} "Sprint"
		Ogre_CampSpot:Set_CCS[-247.665787,180.311218,0.650151]
		if ${Actor["Prysmerah, Arx Patrona"].ID(exists)} && ${Actor["Prysmerah, Arx Patrona"].Distance} <= 20
   			Actor["Prysmerah, Arx Patrona"]:DoTarget
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		Ogre_CampSpot:Set_CCS[-195.179977,183.220154,-8.049913]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		oc !c -CancelMaintainedForWho ${Me.Name} "Sprint"
		Ob_AutoTarget:AddActor["Prysmerah, Arx Patrona",0,FALSE,FALSE]
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 50
		
		echo "AutoTarget Clear"
		Ob_AutoTarget:Clear
		echo " Prysmerah, Arx Patrona is dead, Moving On"
		
       if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		
		return TRUE
    }

	function:bool Named5(string _NamedNPC="Doesnotexist")
	{
			
		;// Starting movement to Final Boss
		;// MOving back to and clicking the door to go in
		;// Pausing bots to move through the door
		echo "Pausing everyone for the click through the door"
		Obj_OgreIH:ChangeCampSpot["-194.678131,183.220154,-0.115376"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		oc !c -pause igzw:${Me.Name}
		wait 10
		Obj_OgreIH:Actor_Click["Door to Arx Seru"]
		wait 60
		;// Adding trash auto target list back
		echo "Adding AutoTarget for trash to speed things up, will clear prior to Name 2"
		Ob_AutoTarget:AddActor["an Arx Luminary",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["a chronal anima",0,FALSE,FALSE]
		Ob_AutoTarget:AddActor["Lord Triskian Seru",0,FALSE,FALSE]
		
		Obj_OgreIH:SetCampSpot
		oc !c -resume igzw:${Me.Name}
		echo "They all should have hit Resume."
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-84.190666,78.122375,3.779922"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		call Obj_OgreUtilities.HandleWaitForCombat
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["-67.723595,78.122375,4.058761"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["-55.078930,78.122375,14.662434"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["8.275904,78.122375,14.418480"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 50
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 20
		if ${Actor["a chronal anima"].ID(exists)} && ${Actor["a chronal anima"].Distance} <= 50
   			Actor["a chronal anima"]:DoTarget
		wait 30
		call Obj_OgreUtilities.HandleWaitForCombat
		wait 20
		Obj_OgreIH:ChangeCampSpot["18.774582,78.122375,31.858877"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["51.629589,77.956970,31.974302"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		Obj_OgreIH:ChangeCampSpot["52.457256,77.969246,4.716171"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		call Obj_OgreUtilities.PreCombatBuff 5
		Obj_OgreIH:ChangeCampSpot["127.888863,79.249512,4.002748"]
		call Obj_OgreUtilities.HandleWaitForCampSpot 10
		wait 10
		if ${Actor["Lord Triskian Seru"].ID(exists)} && ${Actor["Lord Triskian Seru"].Distance} <= 10
   			Actor["Lord Triskian Seru"]:DoTarget
		wait 10
		;// Boss fight, dont know the strat so i Ignore the chronal thingys
		echo "Starting OgreIH KillAll - Ignoring any script cuz I dont know what it is, and the things never come active"
		call Obj_OgreIH.KillAll "${_NamedNPC}" "-KeepGroupBehindOnTarget"


		echo "AutoTarget Clear"
		Ob_AutoTarget:Clear
		echo " Boss is dead, Moving On and out!!"
		
       if ${Actor[namednpc,"${_NamedNPC}"].ID(exists)}
        {
            Obj_OgreIH:Message_FailedToKill["${_NamedNPC}"]
            return FALSE
        }
		
		return TRUE
    }
}