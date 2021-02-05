#define AUTORUN "num lock"
#define CENTER p
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
#define PAGEUP "Page Up"
#define PAGEDOWN "Page Down"
#define WALK shift+r
#define ZOOMIN "Num +"
#define ZOOMOUT "Num -"
#define JUMP Space
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

variable(script) bool StoneSkin
variable(script) int RICrashed
variable(script) int Stucky
variable(script) int SuperStucky
variable(script) bool DoDrones
variable(script) bool DoSlurp
variable(script) bool DoMiniMud
variable(script) bool MeltingMud
variable(script) bool Mudwalker
variable(script) int Snowball=0
variable(script) bool CantSeeTarget
variable(script) int ScriptIdleTime
variable(script) int ZoneTime
variable(script) bool ManualMode
variable(script) string Action
variable(script) int ZoneStuck=0
function main(string questname)
{
	variable int IdleTime=0
	variable float loc0 
	
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	
	ZoneStuck:Set[0]
	
	do
	{
		if (${Script["ToonAssistant"](exists)})
			end ToonAssistant
		echo Zone is ${Zone.Name} (${ZoneStuck} | ${IdleTime} | ${ZoneTime})
		ZoneTime:Set[0]
		loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			
		if (!${Me.Grouped} &&!${Me.InCombatMode})
			eq2execute merc resume
			
		if ${Zone.Name.Equal["Myrist, the Great Library"]}
			call RebootLoop
		if ${Zone.Name.Equal["Awuidor: The Nebulous Deep \[Solo\]"]}
			call Zone_AwuidorTheNebulousDeepSolo
		if ${Zone.Name.Equal["Doomfire: The Enkindled Towers \[Solo\]"]}
			call Zone_DoomfireTheEnkindledTowersSolo
		if ${Zone.Name.Equal["Eryslai: The Midnight Aerie \[Solo\]"]}
			call Zone_EryslaiTheMidnightAerieSolo
		if ${Zone.Name.Equal["Eryslai: The Bixel Hive \[Solo\]"]}
			call Zone_EryslaiTheBixelHiveSolo
		if ${Zone.Name.Equal["Vegarlson: Ruins of Rathe \[Solo\]"]}
			call Zone_VegarlsonRuinsofRatheSolo
		if ${Zone.Name.Equal["Sanctus Seru: Echelon of Order \[Solo\]"]}
			call Zone_SanctusSeruEchelonofOrderSolo
		if ${Zone.Name.Equal["Sanctus Seru: Echelon of Divinity \[Solo\]"]}
			call Zone_SanctusSeruEchelonofDivinitySolo
		if ${Zone.Name.Equal["Sanctus Seru: Arx Aeturnus \[Solo\]"]}
			call Zone_SanctusSeruArxAeturnusSolo
		if ${Zone.Name.Equal["Aurelian Coast: Maiden's Eye \[Solo\]"]}
			call Zone_AurelianCoastMaidensEyeSolo
		if ${Zone.Name.Equal["Aurelian Coast: Reishi Rumble \[Solo\]"]}
			call Zone_AurelianCoastReishiRumbleSolo
		if ${Zone.Name.Equal["Aurelian Coast: Sambata Village \[Solo\]"]}
			call Zone_AurelianCoastSambataVillageSolo
		if ${Zone.Name.Equal["Fordel Midst: The Listless Spires \[Solo\]"]}
			call Zone_FordelMidstTheListlessSpiresSolo
		else
			call MainChecks
		if (${Me.IsIdle} && !${Me.InCombat})
			IdleTime:Inc
		Else
			IdleTime:Set[0]
		call IsPublicZone
		if (${Me.IsIdle} && !${Me.InCombat} && ${Return})
			oc !c -ZoneResetAll ${Me.Name}
		if (${Zone.Name.Left[12].Equal["The Blinding"]} || ${Zone.Name.Left[14].Equal["Aurelian Coast"]} || ${Zone.Name.Left[19].Equal["Sanctus Seru \[City\]"]})
		{
			ZoneStuck:Inc
			call CheckStuck ${loc0}
			if (${Return})
			{
				echo seems stuck in ${Zone.Name}
				if (${Zone.Name.Left[14].Equal["Aurelian Coast"]} && ${Me.Loc.X} < 130 && ${Me.Loc.X} > 110 && ${Me.Loc.Z} < -625 && ${Me.Loc.Z} > -640)
					call navwrap 126 66 -620
				ZoneStuck:Inc
				ZoneStuck:Inc
				ZoneStuck:Inc
				ZoneStuck:Inc
			}
		}
		else
			ZoneStuck:Set[0]	
		ExecuteQueued

		if ((${IdleTime} > 100 || ${ZoneStuck}> 100) && ${Zone.Name.Left[12].Equal["The Blinding"]})
		{
			echo correcting RZ bug that make a toon waiting in the middle of the Blinding for no reason
			call RZStop
			call goFordelMidst
			IdleTime:Set[0]
		}
		if (${ZoneStuck}> 100 && ${Zone.Name.Left[19].Equal["Sanctus Seru \[City\]"]})
		{
			echo call reboot because I am stuck in ${Zone.Name} if (${ZoneStuck}> 100 && ${Zone.Name.Left[19].Equal["Sanctus Seru \[City\]"]})
			run EQ2Ethreayd/safescript wrap RebootLoop
		}
		if ((${ZoneStuck}> 40) && ${Zone.Name.Left[14].Equal["Aurelian Coast"]})
		{
			echo correcting bug
			call RZStop
			call RIStop
			wait 50
			call GoDown
			call navwrap 113 57 -658
			wait 10
			IdleTime:Set[0]
		}
		
		if (${IdleTime} > 100 && !${Zone.Name.Left[12].Equal["The Blinding"]})
		{
			echo Rebooting Loop if (${IdleTime} > 100 && !${Zone.Name.Left[12].Equal["The Blinding"]})
			run EQ2Ethreayd/safescript wrap RebootLoop
		}	
		wait 300
	}
	while (TRUE)
}

function MainChecks()
{
	variable float loc0
	variable bool NearExit
	loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z}]}]
	if (!${Script["ToonAssistant"](exists)})
		run EQ2Ethreayd/ToonAssistant
	echo in MainChecks Loop (${ScriptIdleTime} - ${ZoneTime} - ${SuperStucky})
	ExecuteQueued
	
	if (!${Me.Grouped} && !${Me.InCombatMode})
	{
		eq2execute merc resume
		wait 100
	}
	call IsPresent exit 10
	if ${Return}
		NearExit:Set[TRUE]
	else
		NearExit:Set[FALSE]
	call IsPublicZone
	if (!${Script["Buffer:RunInstances"](exists)} && !${Me.InCombatMode} && !${ManualMode} && !${Return} && !${NearExit})
	{
		RICrashed:Inc
		echo RI seems crashed (test N=${RICrashed})
		
		if (${RICrashed}>5)
		{
			echo RI crashed (${RICrashed}) - restarting zone
			echo Pausing RZ
			RZObj:Pause
			call RIStop
			wait 100
			call Evac
			wait 600
			RI
			wait 100
			RICrashed:Set[0]
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			echo Resuming RZ
			RZObj:Resume
		}
	}
	else
		RICrashed:Set[0]

	if (${ScriptIdleTime}>60 && ${Me.IsDead})
	{
		eq2execute merc suspend
		wait 10
		ChoiceWindow:DoChoice1
	}
	if (${Me.IsDead} && !${Me.Grouped})
	{
		wait 100
		echo Dead and Alone --- Reviving
		call RIRestart TRUE
	}
	call CheckS
	if (!${Return} && !${Me.IsDead})
		echo must be stunned or stifled
	wait 20
	;echo ${loc0}
	call CheckStuck ${loc0}
	if (${Return} && !${Me.InCombatMode})
	{
		Stucky:Inc
		SuperStucky:Inc
		echo Stucky : ${Stucky} / SuperStucky : ${SuperStucky}
	}	
	else
	{
		Stucky:Set[0]
		SuperStucky:Dec
		if ${SuperStucky}<0
		{
			SuperStucky:Set[0]
		}
	}	
	if (${Stucky}>10 && !${NearExit})
	{
		call ISXRIPause
		call UnstuckR 20
		Stucky:Set[0]
		call ISXRIResume
	}
	if ${SuperStucky}>30
	{
		SuperStucky:Set[0]
		if (${NearExit})
		{
			if ${Script["Buffer:RZ"](exists)}
				endscript Buffer:RZ
			echo starting RZ
			RZ
			wait 10
			RZObj:Expac["Blood of Luclin"]
			wait 10
			UIElement[RZm].FindUsableChild[StartButton,button]:LeftClick
		}
		else
			call RIRestart ${Me.IsDead}
	}
	
	call CheckIfRepairIsNeeded 50
	if (${Return})
	{
		call UseRepairRobot
		wait 100
		oc !c -Repair ${Me.Name}
	}
	
	Action:Set["Salvage"]
	if (${Me.InventorySlotsFree}<5)
		call ActionOnPrimaryAttributeValue 1040 ${Action}
	
	call waitfor_Zoning
	call CheckIfRepairIsNeeded 50
	if (${Return})
	{
		call UseRepairRobot
		wait 100
		oc !c -Repair ${Me.Name}
	}
	call IsZoning
	if (!${Return})
	{
		call CheckIfRepairIsNeeded 10
		
		if (((${Me.InventorySlotsFree}<5 && !${Me.IsDead} && !${Me.InCombatMode}) || ${Return}) && ${Me.IsIdle(exists)})
		{
			echo call RebootLoop if (((${Me.InventorySlotsFree}<5 && !${Me.IsDead} && !${Me.InCombatMode}) || ${Return}) && ${Me.IsIdle(exists)}) - ${Me.Equipment["Primary"].ToItemInfo.Condition}
			run EQ2Ethreayd/safescript wrap RebootLoop
		}
	}
	if (${Me.IsIdle} && !${Me.InCombat})
		ScriptIdleTime:Inc
	Else
		ScriptIdleTime:Set[0]
	if (${ScriptIdleTime} > 30)
	{
		echo I am Idle (${ScriptIdleTime}) and I don't know why
		if (${RI_Var_Bool_Paused})
		{
			echo Resuming ISXRI (from MainChecks function)
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
	}
	if (${ZoneTime} > 600)
	{
		echo call RebootLoop if (${ZoneTime} > 600)
		ZoneTime:Set[0]
		run EQ2Ethreayd/safescript wrap RebootLoop
	}
	ZoneTime:Inc
}


function Zone_SanctusSeruEchelonofOrderSolo()
{
	variable int Counter
	ScriptIdleTime:Set[0]
	
	do
	{
		call MainChecks
		if (!${Me.InCombatMode} && ${Me.X} < -365 && ${Me.X} > -385 &&  ${Me.Y} < 90 && ${Me.Y} > 80 && ${Me.Z} < 10 && ${Me.Z} > -10)
		{
			echo ${Me.X} in if 1
			call ActivateVerbOn "circle" "Access"
		}
		if (${Me.X} < -355 && ${Me.X} > -385 &&  ${Me.Y} < 95 && ${Me.Y} > 85 && ${Me.Z} < 40 && ${Me.Z} > 25)
		{
			echo ${Me.X} in if 2
			call ISXRIPause
			call DMove -389 88 13 3 30 TRUE TRUE
			call IsPresent "an Echelon vigilant"
			if ${Return}
				target "an Echelon vigilant"
			call ISXRIResume
		}
		if (${Me.X} < -340 && ${Me.X} > -365 &&  ${Me.Y} < 95 && ${Me.Y} > 85 && ${Me.Z} < 45 && ${Me.Z} > 30)
		{
			echo ${Me.X} in if 3
			call ISXRIPause
			call DMove -381 88 7 3 30 TRUE TRUE
			call DMove -324 90 24 3 30 TRUE TRUE
			call DMove -283 88 165 3 30 TRUE TRUE
			call ISXRIResume
		}	
		if (${Me.X} < -140 && ${Me.X} > -160 &&  ${Me.Y} < 85 && ${Me.Y} > 75 && ${Me.Z} < 280 && ${Me.Z} > 260)
		{
			echo ${Me.X} in if 4
			call ISXRIPause
			call DMove -168 82 270 3 30 TRUE TRUE
			call DMove -91 82 312 3 30 TRUE TRUE
			call ISXRIResume
		}	
		if (${Me.X} < -365 && ${Me.X} > -385 &&  ${Me.Y} < 90 && ${Me.Y} > 80 && ${Me.Z} < -25 && ${Me.Z} > -40)
		{
			echo ${Me.X} in if 5
			RZObj:Pause
			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			call DMove -389 88 -27 3 30 TRUE TRUE 5
			call DMove -378 88 -10 3 30 TRUE TRUE 5
			call DMove -369 91 -28 3 30 TRUE TRUE 5
			call DMove -363 90 -42 3 30 TRUE TRUE 5
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			target "an Echelon vigilant"
			RZObj:Resume
		}
		if (!${Me.InCombatMode} && ${Me.X} < -255 && ${Me.X} > -280 &&  ${Me.Y} < 100 && ${Me.Y} > 85 && ${Me.Z} < 120 && ${Me.Z} > 100)
		{
			echo ${Me.X} in if 6
			RZObj:Pause
			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			call DMove -304 88 96 3 30 TRUE TRUE
			call DMove -298 88 134 3 30 TRUE TRUE
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			RZObj:Resume
		}
		if (${Me.InCombatMode} && !${Me.Target(exists)})
			press Tab 
		if (${Me.InCombatMode} && (${Me.Target.Distance}>10 || ${CantSeeTarget}) && ${Me.X} < -345 && ${Me.X} > -365 &&  ${Me.Y} < 95 && ${Me.Y} > 85 && ${Me.Z} < 40 && ${Me.Z} > 20)
		{
			echo ${Me.X} in if 7
			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			do
			{
				if (!${RI_Var_Bool_Paused})
				{
					echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
					UIElement[RI].FindUsableChild[Start,button]:LeftClick
				}
				echo fixing Seru stucked
				echo Pausing RZ
				RZObj:Pause

				eq2execute merc attack
				press Tab
				
				eq2execute autoattack 0
				wait 20
				eq2execute autoattack 2
				call DMove -358 90 39 3 30 TRUE TRUE 3
				Counter:Inc
				echo if (${Counter}>5)
				wait 50
				if (${Counter}>5)
				{
					call DMove -388 88 31 3 30 TRUE TRUE 3
					call DMove -397 88 0 3 30 TRUE TRUE 3
					call DMove -331 90 24 3 30 TRUE TRUE 3 
					wait 100
					call DMove -331 90 24 3 30 TRUE TRUE 3 
					call DMove -397 88 0 3 30 TRUE TRUE 3
					
					do
					{
						wait 20
					}
					while (${Me.Target.Distance}<15)
					
					call DMove -369 90 27 3 30 TRUE TRUE 3
					call DMove -365 90 40 3 30 TRUE TRUE 3
					call DMove -358 90 39 3 30 TRUE TRUE 3
					Counter:Set[0]
				}
				if (${Me.Target.Distance}<15)
					Counter:Set[0]
			}
			while (${Me.InCombatMode} && ${Me.Target.Distance}>10 && ${Me.X} < -345 && ${Me.X} > -365 &&  ${Me.Y} < 95 && ${Me.Y} > 85 && ${Me.Z} < 40 && ${Me.Z} > 20)	
			echo fixed for this loop
			wait 50
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			echo Resuming RZ
			RZObj:Resume

			CantSeeTarget:Set[FALSE]
		}
		if (${Me.InCombatMode} && (${Me.Target.Distance}>10 || ${CantSeeTarget}) && ${Me.X} < -235 && ${Me.X} > -255 &&  ${Me.Y} < 95 && ${Me.Y} > 85 && ${Me.Z} < 150 && ${Me.Z} > 130)
		{
			echo ${Me.X} in if 8
			RZObj:Pause
			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			echo fixing Seru stucked if (${Me.InCombatMode} && (${Me.Target.Distance}>10 || ${CantSeeTarget}) && ${Me.X} < -235 && ${Me.X} > -255 &&  ${Me.Y} < 95 && ${Me.Y} > 85 && ${Me.Z} < 150 && ${Me.Z} > 130)
		
			eq2execute merc backoff
			call DMove -280 88 152 3 30 TRUE FALSE 5
			eq2execute merc backoff
			call DMove -294 88 112 3 30 TRUE TRUE 5
			eq2execute merc backoff
			call DMove -267 94 94 3 30 TRUE TRUE 5
			eq2execute merc backoff
			call DMove -265 95 117 3 30 TRUE TRUE 
			eq2execute merc attack
			echo fixed for this loop
			wait 50
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			CantSeeTarget:Set[FALSE]
			RZObj:Resume
		}
		if (!${Me.InCombatMode} && ${Me.X} < -270 && ${Me.X} > -290 &&  ${Me.Y} < 95 && ${Me.Y} > 80 && ${Me.Z} < 110 && ${Me.Z} > 95)
		{
			echo ${Me.X} in if 9
			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
				echo fixing Seru stucked
			call DMove -306 88 96 3 30 TRUE TRUE 3 
			echo fixed for this loop
			
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			CantSeeTarget:Set[FALSE]
		}
		if (!${Me.InCombatMode} && ${Me.X} < -200 && ${Me.X} > -220 &&  ${Me.Y} < 95 && ${Me.Y} > 80 && ${Me.Z} < -215 && ${Me.Z} > -235)
		{
			echo ${Me.X} in if 10
			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			echo fixing Seru stucked
			call DMove -205 88 -210 3 30 TRUE TRUE 3 
			echo fixed for this loop
			
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			CantSeeTarget:Set[FALSE]
		}
		ExecuteQueued
		if (${Me.InCombatMode} && (${Me.Target.Distance}>10 || ${CantSeeTarget}) && ${Me.X} < -75 && ${Me.X} > -95 &&  ${Me.Y} < 95 && ${Me.Y} > 75 && ${Me.Z} < 285 && ${Me.Z} > 265)
		{
			echo ${Me.X} in if 11
			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			echo fixing Seru stucked if (${Me.InCombatMode} && (${Me.Target.Distance}>10 || ${CantSeeTarget}) && ${Me.X} < -75 && ${Me.X} > -95 &&  ${Me.Y} < 95 && ${Me.Y} > 75 && ${Me.Z} < 285 && ${Me.Z} > 265)
	
			eq2execute merc backoff
			call DMove -62 85 292 3 30 TRUE FALSE 5
			eq2execute merc backoff
			call DMove -65 82 317 3 30 TRUE FALSE 5
			eq2execute merc backoff
			call DMove -62 85 292 3 30 TRUE FALSE 5
			eq2execute merc backoff
			echo fixed for this loop
			wait 50
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			CantSeeTarget:Set[FALSE]
		}
		if (${Me.InCombatMode} && ${Me.X} < -140 && ${Me.X} > -160 &&  ${Me.Y} < 90 && ${Me.Y} > 75 && ${Me.Z} < -290 && ${Me.Z} > -310)
		{
			echo ${Me.X} in if 12
			press Tab
			wait 300
		}
		if (${Me.X} < -160 && ${Me.X} > -190 &&  ${Me.Y} < 90 && ${Me.Y} > 70 && ${Me.Z} < 235 && ${Me.Z} > 210)
		{
			echo ${Me.X} in if 13
			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			
			call DMove -190 83 221 3 30 TRUE TRUE
			call DMove -213 88 202 3 30 TRUE TRUE
			call DMove -173 88 196 3 30 TRUE TRUE
			call DMove -163 83 239 3 30 TRUE TRUE
			call AttackClosest
			call waitfor_Combat
			call DMove -233 88 200 3 30 TRUE TRUE
			call DMove -172 88 193 3 30 TRUE TRUE
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
		}
		if (${Me.X} < -205 && ${Me.X} > -225 &&  ${Me.Y} < 100 && ${Me.Y} > 80 && ${Me.Z} < -170 && ${Me.Z} > -190)
		{
			echo ${Me.X} in if 14
			RZObj:Pause

			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			
			echo fixing Seru stucked
			call DMove -241 88 -198 3 30 TRUE TRUE
			
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			RZObj:Resume

		}
		if (${Me.X} < -250 && ${Me.X} > -275 &&  ${Me.Y} < 100 && ${Me.Y} > 80 && ${Me.Z} < -80 && ${Me.Z} > -110)
		{
			echo ${Me.X} in if 15
			call ISXRIPause
			
			echo fixing Seru stucked
			call DMove -307 88 -114 3 30 TRUE
			call ISXRIResume

		}
		if (${Me.X} < -170 && ${Me.X} > -195 &&  ${Me.Y} < 100 && ${Me.Y} > 75 && ${Me.Z} < -220 && ${Me.Z} > -240)
		{
			echo ${Me.X} in if 16
			call ISXRIPause
			
			echo fixing Seru stucked
			call DMove -224 88 -207 3 30 TRUE TRUE
			call DMove -197 88 -200 3 30 TRUE TRUE
			call DMove -166 88 -226 3 30 TRUE TRUE
			call ISXRIResume

		}
		if (${Me.X} < -75 && ${Me.X} > -95 &&  ${Me.Y} < 90 && ${Me.Y} > 80 && ${Me.Z} < 280 && ${Me.Z} > 260)
		{
			echo ${Me.X} in if 17
			RZObj:Pause

			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			echo fixing Seru stucked
			eq2execute merc backoff
			face -91 269
			press -hold MOVEFORWARD
			press JUMP
			wait 10
			press JUMP
			wait 10
			press JUMP
			wait 10
			press JUMP
			wait 10
			press JUMP
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			RZObj:Resume

		}
		if (!${Me.InCombatMode} && ${Me.X} < -340 && ${Me.X} > -360 &&  ${Me.Y} < 100 && ${Me.Y} > 80 && ${Me.Z} < -30 && ${Me.Z} > -50)
		{
			echo ${Me.X} in if 18
			RZObj:Pause
			call RIStop
			
			wait 100
			call DMove -360 90 -13 3
			call DMove -402 88 0 3
			call IsPresent "Lady Warglave"
			if (!${Return})
			{	
				RI
				wait 100
				RICrashed:Set[0]
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
				
			}
			else
			{
				call MoveCloseTo "Lady Warglave"
				call TanknSpank "Lady Warglave"
				call MoveCloseTo "Exit"
				do
				{
					call ActivateVerbOn "Exit" "Exit"
					wait 100
				}	
				while (${Zone.Name.Equal["Sanctus Seru: Echelon of Order \[Solo\]"]})
			}
			echo Resuming RZ
			RZObj:Resume
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
		}
		
		wait 10
	}
	while (${Zone.Name.Equal["Sanctus Seru: Echelon of Order \[Solo\]"]})
}
function Zone_SanctusSeruEchelonofDivinitySolo()
{
	variable int Counter
	do
	{
		call MainChecks
		if (${Me.InCombatMode} && ${Me.Target.Distance}>10 && ${Me.X} < -65 && ${Me.X} > -80 &&  ${Me.Y} < 185 && ${Me.Y} > 165 && ${Me.Z} < 160 && ${Me.Z} > 145)
		{
			echo calling merc to backoff
			eq2execute merc backoff
			wait 100
			eq2execute merc attack
		}
		if (!${Me.InCombatMode} && ${Me.X} < -120 && ${Me.X} > -135 &&  ${Me.Y} < 185 && ${Me.Y} > 165 && ${Me.Z} < -200 && ${Me.Z} > -220)
		{
			if (!${RI_Var_Bool_Paused})
			{
				echo Pausing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
			call DMove -145 179 -211 3
			call DMove -123 181 -215 3
			if (${RI_Var_Bool_Paused})
			{
				echo Resuming ISXRI
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			}
		}
		if (!${Me.InCombatMode} && ${Me.X} < -185 && ${Me.X} > -205 &&  ${Me.Y} < 190 && ${Me.Y} > 175 && ${Me.Z} < 10 && ${Me.Z} > -10)
		{
			RZObj:Pause
			call RIStop
			wait 10
			call Evac
			wait 50
			RI
			wait 100
			RICrashed:Set[0]
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			echo Resuming RZ
			RZObj:Resume
		}
		if (!${Me.InCombatMode} && ${Me.X} < -190 && ${Me.X} > -210 &&  ${Me.Y} > 170 && ${Me.Y} < 190 && ${Me.Z} < 10 && ${Me.Z} > -10)
		{
			call ISXRIPause
			oc !c -Special ${Me.Name}
			call ClickOn Door
			call ISXRIResume
		}
		if (${Me.InCombatMode} && !${Me.Target.Distance(exists)})
		{
			Counter:Inc
			if (${Counter}>0)
			{
				Echo in if (${Me.InCombatMode} && !${Me.Target.Distance(exists)}) with (${Counter}>0)
				press Tab
			}
		}
		else
			Counter:Set[0]
		wait 10
		
	}
	while (${Zone.Name.Equal["Sanctus Seru: Echelon of Divinity \[Solo\]"]})
}
function Zone_SanctusSeruArxAeturnusSolo()
{
	
	do
	{
		call MainChecks
		
		
		wait 10
	}
	while (${Zone.Name.Equal["Sanctus Seru: Arx Aeturnus \[Solo\]"]})
}
function Zone_AurelianCoastReishiRumbleSolo()
{
	
	variable int Counter=0
	ScriptIdleTime:Set[0]
	do
	{
		call MainChecks
		echo Zone is ${Zone.Name} (${ScriptIdleTime} | ${ZoneTime})
		
	
		if (!${Me.InCombatMode} && ${Me.X} < 540 && ${Me.X} > 520 &&  ${Me.Y} < 35 && ${Me.Y} > 20 && ${Me.Z} < 435 && ${Me.Z} > 415)
		{
			call ActivateVerbOn "circle" "Access"
			wait 10
		}
		call IsPresent Nerobahan 30
		if (!${Me.InCombatMode} && ${Return})
		{
			echo Will autofight at ${Counter}/20
			Counter:Inc
			if (${Counter}>19)
			{
				Counter:Set[0]
				if (!${RI_Var_Bool_Paused})
					UIElement[RI].FindUsableChild[Start,button]:LeftClick
				call MoveCloseTo Nerobahan
				if (${RI_Var_Bool_Paused})
					UIElement[RI].FindUsableChild[Start,button]:LeftClick
				do
				{
					wait 10
					Counter:Inc
				}
				while (!${Me.InCombatMode} && ${Counter}<50)
				Counter:Set[0]
				call TanknSpank Nerobahan
			}
		}
		call IsPresent Nerobahan 500
		if (!${Me.InCombatMode} && ${Me.X} < 520 && ${Me.X} > 480 &&  ${Me.Y} < 25 && ${Me.Y} > 10 && ${Me.Z} < 530 && ${Me.Z} > 500 && ${Return})
		{
			echo Nerobohan is not dead so I need to kill it myself
			if (!${RI_Var_Bool_Paused})
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			RZObj:Pause
			call DMove 576 17 479 3
			call DMove 633 20 507 3	30 TRUE TRUE		
			call DMove 638 24 582 3 30 TRUE TRUE
			call TanknSpank Nerobahan
			if (${RI_Var_Bool_Paused})
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			RZObj:Resume
		}
		if (!${Me.InCombatMode} && ${Me.X} < 570 && ${Me.X} > 560 &&  ${Me.Y} < 35 && ${Me.Y} > 20 && ${Me.Z} < 520 && ${Me.Z} > 510)
		{
			call DMove 568 19 505 3 30 TRUE TRUE 5
		}
		if (!${Me.InCombatMode} && ${Me.X} < 615 && ${Me.X} > 590 &&  ${Me.Y} < 35 && ${Me.Y} > 25 && ${Me.Z} < 570 && ${Me.Z} > 535)
		{
			call ISXRIPause
			call DMove 609 32 544 3 30 TRUE TRUE
			call DMove 624 24 530 3 30 TRUE TRUE
			call ISXRIResume
		}
		if (!${Me.InCombatMode} && ${Me.X} < 505 && ${Me.X} > 490 &&  ${Me.Y} < 40 && ${Me.Y} > 30 && ${Me.Z} < 575 && ${Me.Z} > 565)
		{
			call ISXRIPause
			call DMove 492 32 593 3 30 TRUE TRUE
			call IsPresent exit
			if ${Return}
				oc !c -Zone ${Me.Name}
			call ISXRIResume
		}
		wait 10
	}
	while (${Zone.Name.Equal["Aurelian Coast: Reishi Rumble \[Solo\]"]})
}
function Zone_AurelianCoastSambataVillageSolo()
{
	
	ScriptIdleTime:Set[0]
	do
	{
		call MainChecks
		echo Zone is ${Zone.Name} (|)

		if (!${Me.InCombatMode} && ${Me.X} < 215 && ${Me.X} > 200 &&  ${Me.Y} < 80 && ${Me.Y} > 65 && ${Me.Z} < -370 && ${Me.Z} > -390)
		{
			call ISXRIPause
			call DMove 213 63 -343 3
			call DMove 182 66 -338 3			
			call DMove 130 62 -359 3
			call ISXRIResume
		}
		if (!${Me.InCombatMode} && ${Me.X} < 85 && ${Me.X} > 70 &&  ${Me.Y} < 85 && ${Me.Y} > 70 && ${Me.Z} < -180 && ${Me.Z} > -205)
		{
			call ISXRIPause
			call DMove 186 63 -311 3
			call ISXRIResume
		}
		if (!${Me.InCombatMode} && ${Me.X} < -30 && ${Me.X} > -50 &&  ${Me.Y} < 80 && ${Me.Y} > 65 && ${Me.Z} < -650 && ${Me.Z} > -680)
		{
			call ISXRIPause
			call RebootLoop
		}
		; must be the LAST test of the loop
		if (!${Me.InCombatMode} && ${Me.X} < -130 && ${Me.X} > -150 &&  ${Me.Y} < 90 && ${Me.Y} > 70 && ${Me.Z} < -680 && ${Me.Z} > -700)
		{
			if (!${Script["Buffer:RunInstances"](exists)})
				call ActivateVerbOn "Zone exit" Exit
			call ISXRIPause
			wait 300	
			if ${Zone.Name.Equal["Aurelian Coast: Sambata Village \[Solo\]"]}
			{
				call DMove -78 82 -704 3
				call IsPresent Grrrunk 500
				if (${Return})
				{
					call DMove -46 83 -672 3
					call DMove -35 89 -635 3
					call DMove 9 90 -607 3
					call DMove 16 87 -592 3
					call DMove 47 79 -576 3
					call TanknSpank "Grrrunk the Trunk"
					call DMove 47 79 -576 3
					call DMove 16 87 -592 3
					call DMove 9 90 -607 3
					call DMove -35 89 -635 3
					call DMove -46 83 -672 3
					call DMove -78 82 -704 3
				}
				call DMove -136 82 -687 3 30 TRUE TRUE
				call TanknSpank "Mrokor"
				call TanknSpank "Purpyron"
				
			}
			call ISXRIResume
			wait 600
		}
		wait 10
	}
	while (${Zone.Name.Equal["Aurelian Coast: Sambata Village \[Solo\]"]})
}
function Zone_AurelianCoastMaidensEyeSolo()
{
	
	variable int Counter=0
	
	ScriptIdleTime:Set[0]
	do
	{
		call MainChecks
		echo Zone is ${Zone.Name} (${Counter})

		if (!${Me.InCombatMode} && ${Me.X} < -185 && ${Me.X} > -205 &&  ${Me.Y} < 10 && ${Me.Y} > 0 && ${Me.Z} < 40 && ${Me.Z} > 25)
		{
			call ActivateVerbOn "circle" "Access"
			wait 10
		}
		
		if (!${Me.InCombatMode} && ${Me.X} < -425 && ${Me.X} > -435 &&  ${Me.Y} < 15 && ${Me.Y} > -5 && ${Me.Z} < -265 && ${Me.Z} > -285)
		{
			if (!${RI_Var_Bool_Paused})
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			wait 20
			call DMove -428 4 -278 3
			call DMove -349 4 -273 3
			wait 20
			if (${RI_Var_Bool_Paused})
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			
		}
		
		call IsPresent "Xylox the Poisonous"
		if (!${Me.InCombatMode} && ${Return})
		{
			echo Will autofight at ${Counter}/20
			Counter:Inc
			if (${Counter}>19)
			{
				if (!${RI_Var_Bool_Paused})
					UIElement[RI].FindUsableChild[Start,button]:LeftClick
				call MoveCloseTo "Xylox the Poisonous"
				if (${RI_Var_Bool_Paused})
					UIElement[RI].FindUsableChild[Start,button]:LeftClick
				do
				{
					wait 10
				}
				while (!${Me.InCombatMode})
				call TanknSpank "Xylox the Poisonous"
				wait 10
				OgreBotAPI:UplinkOptionChange["${Me.Name}","checkbox_autotarget_outofcombatscanning","FALSE"]
				Counter:Set[0]
			}
		}
		else
			Counter:Set[0]
		if (!${Me.InCombatMode} && ${Me.InCombatMode(exists)} && ${Me.X} < -515 && ${Me.X} > -535 &&  ${Me.Y} < 10 && ${Me.Y} > -10 && ${Me.Z} < 20 && ${Me.Z} > 0)
		{
			run EQ2Ethreayd/safescript wrap RebootLoop
		}
		if (${Me.InCombatMode} && ${Me.X} < -445 && ${Me.X} > -465 &&  ${Me.Y} < 10 && ${Me.Y} > -10 && ${Me.Z} < -90 && ${Me.Z} > -110)
		{
			Counter:Inc
			if (${Counter2}>19)
			{
				call AttackClosest
				Counter:Set[0]
			}
		}
		else
			Counter:Set[0]
		if (!${Me.InCombatMode} && ${Me.X} < -385 && ${Me.X} > -400 &&  ${Me.Y} < 10 && ${Me.Y} > -10 && ${Me.Z} < -260 && ${Me.Z} > -280)
		{
			Counter:Inc
			if (${Counter}>19)
			{
				if (!${RI_Var_Bool_Paused})
					UIElement[RI].FindUsableChild[Start,button]:LeftClick
				call DMove -390 0 -294 3 30
				call DMove -346 3 -276 3 30
				
				if (${RI_Var_Bool_Paused})
					UIElement[RI].FindUsableChild[Start,button]:LeftClick
				Counter:Set[0]
			}
		}
		else
			Counter:Set[0]
		if (!${Me.InCombatMode} && ${Me.X} < -525 && ${Me.X} > -545 &&  ${Me.Y} < 50 && ${Me.Y} > 0 && ${Me.Z} < 25 && ${Me.Z} > 0)
		{
			RZObj:Pause
			if (!${RI_Var_Bool_Paused})
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			call DMove -459 7 18 3
			call DMove -333 3 -117 3
			call DMove -323 5 -227 3
			call DMove -432 25 -237 3
			call DMove -474 33 -208 3
			call DMove -567 54 -48 3
			if (${RI_Var_Bool_Paused})
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			RZObj:Resume	
		}
		if (!${Me.InCombatMode} && ${Me.X} < -485 && ${Me.X} > -510 &&  ${Me.Y} < 10 && ${Me.Y} > -10 && ${Me.Z} < -5 && ${Me.Z} > -30)
		{
			Counter:Inc
			if (${Counter}>19)
			{
				RZObj:Pause
				if (!${RI_Var_Bool_Paused})
					UIElement[RI].FindUsableChild[Start,button]:LeftClick
				call DMove -178 3 51 3 30
				oc !c -Special ${Me.Name}
				call RIStop
				RZObj:Resume
				Counter:Set[0]
			}
		}
		else
			Counter:Set[0]
		wait 10
	}
	while (${Zone.Name.Equal["Aurelian Coast: Maiden's Eye \[Solo\]"]})
}

function Zone_FordelMidstTheListlessSpiresSolo()
{
	
	variable int Counter=0
	
	ScriptIdleTime:Set[0]
	do
	{
		call MainChecks
		echo Zone is ${Zone.Name} (${Counter})

		if (!${Me.InCombatMode} && ${Me.X} < 305 && ${Me.X} > 285 &&  ${Me.Y} < -20 && ${Me.Y} > -40 && ${Me.Z} < 930 && ${Me.Z} > 900)
		{
			call ActivateVerbOn "door entrance" "Open"
		}
		wait 10
		if (!${Me.InCombatMode} && ${Me.X} < 285 && ${Me.X} > 260 &&  ${Me.Y} < -20 && ${Me.Y} > -50 && ${Me.Z} < 740 && ${Me.Z} > 710 && !${Script["Buffer:RunInstances"](exists)})
		{
			call ActivateVerbOn "Aurelian Coast" "Aurelian Coast"
		}
		wait 10
	}
	while (${Zone.Name.Equal["Fordel Midst: The Listless Spires \[Solo\]"]})
}

function DoMound()
{
	echo going to mound
	if (!${RI_Var_Bool_Paused})
		UIElement[RI].FindUsableChild[Start,button]:LeftClick
	do
	{
		call MoveCloseTo "vekerchiki mound"
		call TanknSpank "vekerchiki mound" 25
		wait 50
		call IsPresent "vekerchiki mound" 20
	}
	while (${Return})
	if (${RI_Var_Bool_Paused})
		UIElement[RI].FindUsableChild[Start,button]:LeftClick
}
function DoMud()
{
	echo starting DoMud function
	ExecuteQueued
	wait 20
	if (!${Me.InCombatMode})
	{
		call IsPresent "muddite lurcher" 20 TRUE
		if (${Return} && !${MeltingMud} && !${Actor["muddite lurcher"].CheckCollision} && !${Actor["muddite lurcher"].IsAggro})
		{
			call ActivateAll "muddite lurcher" "Apply sticky vekerchiki mud" 20
			wait 20
			if ${DoMiniMud}
			{
				do
				{
					wait 50		
					call IsPresent "minimud" 30
				}
				while (!${Return})
				call TanknSpank "minimud" 30
				DoMiniMud:Set[FALSE]
			}
		}
	}
	else
		call DoMud
}
function FightGlimmerstone()
{
	variable string Named
	Named:Set[Glimmerstone]
	echo starting ${Named} fight script
	do
	{
		wait 10
		call IsPresent "${Named}" 20
	}
	while (!${Return})
	StoneSkin:Set[TRUE]
	do
	{
		face "${Named}" 
		target "${Named}"
		wait 10
		call IsPresent "${Named}" 200	
	}
	while (!${StoneSkin} && ${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	press F1
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	call DMove -314 38 -234 3 30 TRUE FALSE 10
	call DMove -340 37 -235 3 30 TRUE FALSE 5
	call PKey "Page Up" 3
	call PKey ZOOMOUT 20
	call ActivateAggro "Runic Stone" Activate 10
	StoneSkin:Set[FALSE]
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		target "Runic Stone"
		wait 10
		call IsPresent "Runic Stone" 10
	}
	while (${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	press F1
	call DMove -340 37 -235 3 30 TRUE FALSE 5
	call DMove -314 38 -234 3 30 TRUE FALSE 10
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		call PullNamed "${Named}"
		wait 10
		call IsPresent "${Named}" 200	
	}
	while (!${StoneSkin} && ${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	press F1
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	call DMove -309 37 -176 3 30 TRUE FALSE 10
	call DMove -323 36 -172 3 30 TRUE FALSE 5
	call ActivateAggro "Runic Stone" Activate 10
	StoneSkin:Set[FALSE]
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		target "Runic Stone"
		wait 10
		call IsPresent "Runic Stone" 10
	}
	while (${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	press F1
	call DMove -323 36 -172 3 30 TRUE FALSE 5
	call DMove -309 37 -176 3 30 TRUE FALSE 10
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		call PullNamed "${Named}"
		wait 10
		call IsPresent "${Named}" 200	
	}
	while (!${StoneSkin} && ${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	press F1
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	call DMove -271 38 -215 3 30 TRUE FALSE 10
	call DMove -236 32 -242 3 30 TRUE FALSE 5
	call ActivateAggro "Runic Stone" Activate 10
	StoneSkin:Set[FALSE]
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		target "Runic Stone"
		wait 10
		call IsPresent "Runic Stone" 10
	}
	while (${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	press F1
	call DMove -236 32 -242 3 30 TRUE FALSE 5
	call DMove -268 38 -213 3 30 TRUE FALSE 10
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		call PullNamed "${Named}"
		wait 10
		call IsPresent "${Named}" 200		
	}
	while (!${StoneSkin} && ${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	press F1
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	call DMove -304 35 -196 3 30 TRUE FALSE 10
	call DMove -271 32 -155 3 30 TRUE FALSE 10
	call DMove -243 33 -157 3 30 TRUE FALSE 5
	if (!${DoSlurp})
		call ActivateAggro "Runic Stone" Activate 10
	StoneSkin:Set[FALSE]
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		target "Runic Stone"
		wait 10
		call IsPresent "Runic Stone" 10
	}
	while (${Return})
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	press F1
	call DMove -243 33 -157 3 30 TRUE FALSE 5
	call DMove -284 32 -160 3 30 TRUE FALSE 10
	call DMove -278 37 -213 3 30 TRUE FALSE 10
	call DMove -289 37 -230 3 30 TRUE FALSE 5
	UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
	do
	{
		call PullNamed "${Named}"
		wait 10
		call IsPresent "${Named}" 200		
	}
	while (!${StoneSkin} && ${Return})
	call TanknSpank "${Named}"
	wait 20
	call PKey "Page Down" 3
	call gotoSlurpgaloop
}
function FightNajena()
{
	echo waiting for Lady Najena fight
	do
	{
		wait 10
		call IsPresent "Lady Najena" 30
	}
	while (!${Return})
	ManualMode:Set[TRUE]
	do
	{
		wait 10
	}
	while (!${Actor["Lady Najena"].IsAggro})
	target "Lady Najena"
	wait 100
	press F1
	call DMove 605 14 -312 3 30 TRUE TRUE 5
	do
	{
		
		do
		{
			target "Lady Najena"
			eq2execute merc attack
			wait 200
			eq2execute merc backoff
			call IsPresent "Lady Najena" 20
		}
		while (!${Return})
		
		call IsPresent "snowboulder"
		if (${Return})
		{
			call ActivateVerbOn "snowboulder" "Pick up" TRUE
			wait 20
			call NextBoulder ${Snowball}
			if (${Mudwalker})
			{
				press F1
				call DMove 595 14 -312 3 30 TRUE TRUE 5
			}
			wait 50
		}
		wait 10
		ExecuteQueued
		call IsPresent "Lady Najena" 500
	}
	while (${Return} && ${Number}<5)
	call DMove 471 14 -296 3 30 TRUE TRUE 5
	do
	{
		call ActivateVerbOn "teleporter from Najena fight" Examine TRUE
		wait 20
		call ActivateVerbOn "teleporter from Najena fight" Teleport TRUE
		wait 20
	}
	while (${Me.X}>0)
	call DMove -345 43 -404 3
	do
	{
		call ActivateVerbOn Exit Exit TRUE
	}
	while (${Zone.Name.Equal["Vegarlson: Ruins of Rathe \[Solo\]"]})
	ManualMode:Set[FALSE]
}
function gotoForrestBarrens()
{
	echo killing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
	RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
	call DMove 407 18 325 3
	call DMove 383 22 324 3
	call DMove 375 26 307 2
	call DMove 383 23 284 3
	call DMove 395 41 221 3
	call DMove 445 37 161 2
	ogre hl
	wait 100
	ogre end hl
	call DMove 401 40 224 3
	call DMove 381 30 267 3
	call DMove 365 42 287 3
	call DMove 353 47 312 3
	call DMove 310 77 309 3
	call gotoHeaper
}
function gotoHeaper()
{	
	call DMove 275 78 317 3
	call DMove 230 76 297 3
	call DoMound
	call DMove 193 70 307 3
	call DMove 137 57 286 3
	call DMove 119 57 318 3
	call DoMound
	call DMove 145 61 344 3
	call DMove 130 44 377 3
	call DoMound
	call DMove 223 41 396 3
	call DoMound
	call DMove 204 40 413 3
	call DoMound
	call DMove 266 48 481 3
	call DoMound
	call DMove 234 39 445 3
	call DMove 195 47 472 3
	call DoMound
	wait 20
	RI
	wait 50
	if (${RI_Var_Bool_Paused})
		UIElement[RI].FindUsableChild[Start,button]:LeftClick
}
function gotoSlurpgaloop()
{
	variable string Named
	Named:Set[Slurpgaloop]
	echo Glimmerstone is done
	call DMove -295 37 -232 3
	call DMove -270 37 -213 3
	call DMove -253	39 -219 3
	call DMove -193 32 -172 3
	call DMove -182 31 -149 3
	call DMove -118 33 -123 3
	call DMove -123 39 -84 3
	call DMove -93 50 -50 3
	call DMove -4 97 -19 3
	call DMove -10 106 16 3
	call DMove -24 106 16 3
	call DMove -20 111 27 2
	call DMove -8 88 60 3
	call DMove 4 104 58 3
	call DMove 1 111 86 3
	call DMove 44 94 164 3
	call DMove 91 93 158 3
	call DMove 113 92 174 3
	call DMove 156 89 180 3
	call DMove 202 107 157 2
	call DMove 235 109 193 3
	call DMove 259 109 200 3
	wait 20
	call IsPresent "${Named}" 2000
	if (${Return})
	{
		RI
		wait 50
		if (${RI_Var_Bool_Paused})
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		do
		{
			wait 10
			call IsPresent "${Named}" 500
		}
		while (${Return})
		echo Slurpgaloop is done
		DoDrones:Set[TRUE]
		echo activating DoDrones variable at ${DoDrones}
		;if (${Me.Y} < 50)
		call gotoForrestBarrens
	}
	else
	{
		call DMove 255 110 196 3
		call DMove 255 76 271 3
		call DoMound
		call DMove 280 77 312 3
		call gotoHeaper
	}
}

function NextBoulder(int Number)
{
	press F9
	call PKey PAGEDOWN 20
	call PKey PAGEUP 5
	press F1
	call DMove 595 14 -312 3 30 TRUE FALSE 5
	echo moving to ${Number} loc 
	if (${Number}==0)
	{
		echo moving to loc 0 (${Number})
		call DMove 592 13 -310 3 30 TRUE FALSE 5
	}
	if (${Number}==1)
	{
		echo moving to loc 1 (${Number})
		call DMove 566 13 -307 3 30 TRUE FALSE 5
	}
	if (${Number}==2)
	{
		echo moving to loc 2 (${Number})
		call DMove 538 13 -305 3 30 TRUE FALSE 5
	}
	if (${Number}==3)
	{
		echo moving to loc 3 (${Number})
		call DMove 515 13 -303 3 30 TRUE FALSE 5
	}
	if (${Number}==4)
	{
		echo moving to loc 4 (${Number})
		call DMove 490 13 -299 3 30 TRUE FALSE 5
	}
	echo clicking	
	MouseTo 1000,750
	wait 10
	Mouse:LeftClick
	press F9
	if (${Number}<5)
	{
		echo moving back
		press F1
		call DMove 595 14 -312 3 30 TRUE FALSE 5
	}
}

function ResetMeltingMud()
{
	wait 100
	MeltingMud:Set[FALSE]
}
function Zone_AwuidorTheNebulousDeepSolo()
{
	do
	{
		call MainChecks
		call CloseCombat "Pontis Aqueous" 35
		if (${Me.X} < -1350 && ${Me.X} > -1365 &&  ${Me.Y} < 615 && ${Me.Y} > 600 && ${Me.Z} < 30 && ${Me.Z} > 15)
		{
			echo correcting ISXRI Bug with stuck
			call DMove -1376 610 19 2
		}
		if (${Me.X} < 1370 && ${Me.X} > -1355 &&  ${Me.Y} < 620 && ${Me.Y} > 600 && ${Me.Z} < 30 && ${Me.Z} > 15)
		{
			echo correcting ISXRI Bug with stuck
			call DMove 1376 610 19 2
		}
		if (${Me.X} < 10 && ${Me.X} > -10 &&  ${Me.Y} < 615 && ${Me.Y} > 600 && ${Me.Z} < -1300 && ${Me.Z} > -1315)
		{
			echo correcting ISXRI Bug with stuck
			call DMove 1 611 -1323 2
		}
		if (${Me.X} < 10 && ${Me.X} > -10 &&  ${Me.Y} < 615 && ${Me.Y} > 600 && ${Me.Z} > 1295 && ${Me.Z} < 1310)
		{
			echo correcting ISXRI Bug with stuck
			call DMove 0 611 1314 2
		}
		wait 1000
	}
	while (${Zone.Name.Equal["Awuidor: The Nebulous Deep \[Solo\]"]})
}
function Zone_DoomfireTheEnkindledTowersSolo()
{
	echo Entering Doomfire Solo loop
	do
	{
		call MainChecks
		call CloseCombat "Ra-Sekjet, the Molten" 60 TRUE
		wait 1000
	}
	while (${Zone.Name.Equal["Doomfire: The Enkindled Towers \[Solo\]"]})
}

function Zone_EryslaiTheMidnightAerieSolo()
{
	variable string Named
	do
	{
		call MainChecks
		Named:Set["Beaknik"]
		call IsPresent "${Named}" 50
		if (${Return} && ${Me.X} < 960 && ${Me.X} > 940 &&  ${Me.Y} < 255 && ${Me.Y} > 245 && ${Me.Z} < 320 && ${Me.Z} > 310)
		{
			echo correcting ISXRI Bug (stuck in ${Named} fight)
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			wait 20
			call DMove 955 258 264 3
			wait 10
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		
		wait 1000
	}
	while (${Zone.Name.Equal["Eryslai: The Bixel Hive \[Solo\]"]})
}

function Zone_EryslaiTheBixelHiveSolo()
{
	variable string Named
	do
	{
		call MainChecks
		Named:Set["Daishani"]
		
		call IsPresent "${Named}" 50
		if (${Return} && ${Actor["${Named}"].IsAggro})
		{
			echo correcting ISXRI Bug with ${Named} fight...
			face "${Named}"
			target "${Named}"
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			call DMove -634 403 -161 3 30 TRUE TRUE 10
			eq2execute merc attack
			wait 600
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		call IsPresent "?" 5
		if (${Return} && ${Me.X} < -490 && ${Me.X} > -500 &&  ${Me.Y} < 650 && ${Me.Y} > 635 && ${Me.Z} < -170 && ${Me.Z} > -180)
		{
			echo correcting ISXRI Bug with shiny
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			wait 20
			call DMove -530 643 -179 1
			call DMove -520 642 -176 1 30 FALSE FALSE 3
			call DMove -530 644 -170 1 30 FALSE FALSE 3
			call DMove -544 648 -179 1 30 FALSE FALSE 3
			wait 10
			ogre hl
			wait 100
			ogre end hl
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		call IsPresent "?" 10
		if (${Return} && ${Me.X} < -665 && ${Me.X} > -675 &&  ${Me.Y} < 410 && ${Me.Y} > 395 && ${Me.Z} < -185 && ${Me.Z} > -200)
		{
			echo correcting ISXRI Bug with shiny
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			wait 20
			call DMove -665 403 -190 2 30 FALSE FALSE 3
			call DMove -670 403 -197 2 30 FALSE FALSE 3
			call DMove -676 403 -197 2 30 FALSE FALSE 3
			wait 20
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			ogre hl
			wait 100
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			ogre hl
			wait 100
			ogre end hl
			call DMove -676 403 -197 2 30 FALSE FALSE 3
			call DMove -670 403 -197 2 30 FALSE FALSE 3
			call DMove -665 403 -190 2 30 FALSE FALSE 3
			wait 20
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		if (${Me.X} < -490 && ${Me.X} > -500 &&  ${Me.Y} < 650 && ${Me.Y} > 635 && ${Me.Z} < -170 && ${Me.Z} > -190)
		{
			echo correcting ISXRI Bug with last fight
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
			UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
			press F1
			wait 20
			press F1
			call DMove -485 639 -174 3 30 TRUE FALSE 5
			press F1
			wait 10
			call MoveJump -507 641 -176 -494 639 -174
			call DMove -546 648 -172 3 30 TRUE FALSE 5
			UIElement[CombatBotMiniUI].FindUsableChild[Pause,button]:LeftClick
			call TanknSpank Aurorax
			UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		wait 1000
	}
	while (${Zone.Name.Equal["Eryslai: The Bixel Hive \[Solo\]"]})
}
function Zone_VegarlsonRuinsofRatheSolo()
{
	do
	{
		call MainChecks
		call IsPresent "Runic Stone" 2000
		eq2execute loc
		if (${Me.InCombatMode} && ${Me.Target.Distance}>30)
			press F1
		if (!${Return} && ${Me.X} < -230 && ${Me.X} > -320 &&  ${Me.Y} < 45 && ${Me.Y} > 25 && ${Me.Z} < -180 && ${Me.Z} > -270)
		{
			call IsPresent "Living Stone" 100
			if (!${Return})
			{
				echo killing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
				RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
				call DMove -291 37 -224 3 30 TRUE TRUE 10
				call gotoSlurpgaloop
			}
		}
		call IsPresent "Glimmerstone" 20
		if (${Return})
		{
			echo killing ISXRI - ISXRIAssistant is taking over until @Herculezz fix the damn thing
			RIObj:EndScript;ui -unload "${LavishScript.HomeDirectory}/Scripts/RI/RI.xml"
			call DMove -291 37 -224 3 30 TRUE TRUE 10
			call FightGlimmerstone
		}
		call IsPresent "Runic Stone" 20
		if (${Return})
		{
			do
			{
				call MoveCloseTo "Runic Stone"
				call ActivateVerbOn "Runic Stone" Push TRUE
				wait 10
				call IsPresent "Runic Stone" 20
			}
			while (${Return})
		}
		call IsPresent "vekerchiki mound" 50
		if (${Return} && ((${Me.X} < 240 && ${Me.X} > 210 && ${Me.Y} < 115 && ${Me.Y} > 100 && ${Me.Z} < 210 && ${Me.Z} > 180) || (${Me.X} < 280 && ${Me.X} > 250 && ${Me.Y} < 115 && ${Me.Y} > 100 && ${Me.Z} < 200 && ${Me.Z} > 180)))
			call DoMound
		call IsPresent "vekerchiki mound" 30
		if (${Return} && ${DoDrones})
			call DoMound
		
		call IsPresent "The Monstrous Mudwalker" 500
		if (${Return})
			Mudwalker:Set[TRUE]
		else
			Mudwalker:Set[FALSE]
		
		call IsPresent "muddite lurcher" 10
		if (${Return} && !${Mudwalker})
		{
			if (!${RI_Var_Bool_Paused})
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
			
			call DMove -68 24 577 3 30 TRUE
			call DoMud
			call DMove -53 15 601 3 30 TRUE
			call DoMud
			call DMove -52 17 625 3 30 TRUE
			call DoMud
			call DMove -48 18 670 3 30 TRUE
			call DoMud
			call DMove -77 15 685 3 30 TRUE
			call DoMud
			call DMove -68 24 577 3 30 TRUE
			call DoMud
			call DMove -63 22 738 3 30 TRUE
			call DoMud
			call DMove -68 24 577 3 30 TRUE
			call DoMud
			call DMove -77 15 685 3 30 TRUE
			call DoMud
			call DMove -48 18 670 3 30 TRUE
			call DoMud
			call DMove -52 17 625 3 30 TRUE
			call DoMud
			call DMove -53 15 601 3 30 TRUE
			call DoMud
			call DMove -68 24 577 3 30 TRUE
			call DoMud
			if ${RI_Var_Bool_Paused}
				UIElement[RI].FindUsableChild[Start,button]:LeftClick
		}
		call IsPresent "Koni Ferus" 20
		if (${Return})
		{
			echo Final fight detected
			do
			{
				wait 10
				call IsPresent "Koni Ferus" 20
			}
			while (${Return})
			do
			{
				wait 10
				call IsPresent "Pete Bog" 20
			}
			while (${Return})
			Snowball:Set[0]
			echo all named defeated - checking quest
			call check_quest "Elements of Destruction: Planes of Disorder"
			if (${Return})
			{
				call FightNajena
			}
		}
		ExecuteQueued
		wait 10
	
		call IsPresent "Lady Najena" 40
		if (${Return})
			call FightNajena
	}
	while (${Zone.Name.Equal["Vegarlson: Ruins of Rathe \[Solo\]"]})
}
atom HandleAllEvents(string Message)
{
	if (${Message.Equal["Can't see target"]})
	{
		eq2execute gsay ${Message}
		CantSeeTarget:Set[TRUE]
	}

	if (${Message.Equal["Too far away"]})
	{
		 eq2execute gsay ${Message}
	}
	if (${Message.Find["seeks protection within the stones"]}>0)
	{
		echo Named has stoneskin on
		StoneSkin:Set[TRUE]
	}
	if (${Message.Find["deafening,"]}>0)
	{
		echo Named Slurpgaloop is spawned
		DoSlurp:Set[TRUE]
	}
	if (${Message.Find["disturbance of the hive has caused an enormous"]}>0)
	{
		echo Named Heaper is spawned
		DoDrones:Set[FALSE]
	}
	if (${Message.Find["stirs in the center of one of the mud"]}>0)
	{
		echo Named Mudwalker is spawned
		Mudwalker:Set[TRUE]
	}
	if (${Message.Find["dodrones"]}>0)
	{
		echo manual DoDrones set at TRUE
		DoDrones:Set[TRUE]
	}
	if (${Message.Find["flows out of the Muddy Lagoon"]}>0)
	{
		echo MiniMud is spawned
		DoMiniMud:Set[TRUE]
	}
	if (${Message.Find["Get out of the water"]}>0)
	{
		echo Melting in mud
		MeltingMud:Set[TRUE]
		QueueCommand call ResetMeltingMud
		Snowball:Dec
		if ${Snowball}<0
			Snowball:Set[0]
		echo Bridger part ${Snowball}/5 done
	}
	if (${Message.Find["snow boulder froze a section"]}>0)
	{
		Snowball:Inc
		echo Bridger part ${Snowball}/5 done
	}
	if (${Message.Find["have already been frozen"]}>0)
	{
		Snowball:Inc
		echo resuming to part ${Snowball}/5
	}
	if (${Message.Find["ve got better things to do"]}>0)
	{
		echo Merc gone because of inactivity - Rebooting loop
		QueueCommand run EQ2Ethreayd/safescript wrap RebootLoop
	}
	if (${Message.Find["must first be taken down"]}>0)
	{
		call ActivateVerbOn "circle" "Access"
	}
	if (${Message.Find["Saperlipopette"]}>0 && !${RI_Var_Bool_Paused})
	{
		UIElement[RI].FindUsableChild[Start,button]:LeftClick
		QueueCommand UIElement[RI].FindUsableChild[Start,button]:LeftClick
	}
	if (${Message.Find["RROR: Destination zone name can not be determined"]}>0)
	{
		call Log "Lost in some zone and fast travel is not working - Rebooting loop" WARNING
		QueueCommand run EQ2Ethreayd/safescript wrap RebootLoop
	}
}
atom HandleEvents(int ChatType, string Message, string Speaker, string TargetName, bool SpeakerIsNPC, string ChannelName)
{
}