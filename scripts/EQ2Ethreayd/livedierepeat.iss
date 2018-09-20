#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/CoVZones.iss"

function main(bool NoShiny, bool Heroic)
{
	variable bool GroupDead
	variable bool GroupAlive
	variable float loc0
	variable int Counter
	variable int Stucky
	variable string sQN
	variable int Restart=0
	variable int i
	do
	{
		echo start ldr loop
		Stucky:Set[0]
		do
		{
			loc0:Set[${Math.Calc64[${Me.Loc.X} * ${Me.Loc.X} + ${Me.Loc.Y} * ${Me.Loc.Y} + ${Me.Loc.Z} * ${Me.Loc.Z} ]}]
			wait 100
			call isGroupDead
			GroupDead:Set[${Return}]
			call isGroupAlive
			GroupAlive:Set[${Return}]
			if ${Me.IsDead}
			{
				Counter:Inc
				echo Counter: ${Counter}
			}
			else
			{
				Counter:Set[0]
				echo Resetting Counter : I'm not dead !!!
			}
			call CheckStuck ${loc0}
			if (${Return} && !${Me.InCombatMode} )
			{
				Stucky:Inc
				echo Stucky: ${Stucky}
			}
			else
				Stucky:Dec
			call GroupDistance
			echo Max Distance of a group member : ${Return}m
		}
		while ((${GroupAlive} || ${Heroic}) && !${GroupDead} && ${Counter}<30 && ${Stucky}<60 && ${Return}<30)
		echo Live and let die ! ((${GroupAlive} || ${Heroic}) && !${GroupDead} && ${Counter}<30 && ${Stucky}<60 && ${Return}<30)
		
		if (!${GroupAlive})
		{
			for ( i:Set[0] ; ${i} < ${Me.GroupCount} ; i:Inc )
			{
				if (${Me.Group[${i}].IsDead})
				{
					oc !c -CastAbilityOnPlayer All "Gather Remains" ${Me.Group[${i}].Name}
					wait 100
				}
			}
		}
		if (${Me.IsDead} && ${Me.InventorySlotsFree}>0)
		{
			echo in loop - waiting 30s
			wait 300
			if (${Me.IsDead})
			{
				echo I am Dead - Rebooting Instance (${sQN})
				Restart:Inc
				echo Restart counter at ${Restart}
				if ${Script["autoshinies"](exists)}
					endscript autoshinies
				if ${Script["LoopHeroic"](exists)}
						Script["LoopHeroic"]:Pause
				call StopHunt
				call EndZone
				if ${Script["wrap"](exists)}
					endscript wrap
				if (${Heroic})
				{
					oc !c -letsgo 
					oc !c -revive all 0
					wait 100
					relay all ogre
					wait 300
				}
				else
				{
					oc !c -letsgo ${Me.Name}
					oc !c -revive ${Me.Name} 0
				}
				echo waiting 1 min to recover
				wait 600
				call ReturnEquipmentSlotHealth Primary
				if (!${Heroic} && ${Return}<20)
				{
					echo LDR: if (!${Heroic} && ${Return}<20)
					echo Gear is too damaged - Returning to GH
					call goto_GH
					call GuildH
					wait 100
					call goCoV
				}
				if (${Heroic} && ${Return}<100 && ${Restart}<10)
				{
					echo LDR: if (${Heroic} && ${Return}<100 && ${Restart}<2)
					Me.Inventory["Mechanized Platinum Repository of Reconstruction"]:Use
					wait 50
					echo Repair
					oc !c -repair
					wait 50
				}
				if (${Heroic} && ${Restart}>1)
				{
					echo LDR: if (${Heroic} && ${Restart}>9)
					
					echo Zone is too hard for this team - Exiting
					oc !c -pause
					call ExitZone
					
					wait 100
					oc !c -resume
					oc !c -ZoneResetAll
					if ${Script["LoopHeroic"](exists)}
						Script["LoopHeroic"]:Resume
					else
						run EQ2Ethreayd/LoopHeroic
				}
				if ((!${Heroic} && ${Return}>10)||(${Heroic} && ${Restart}<5))
				{
					echo  LDR: if ((!${Heroic} && ${Return}>10)||(${Heroic} && ${Restart}<5))
					echo Restarting Zone from LDR
					run EQ2Ethreayd/wrap RunZone 0 0 0 ${NoShiny}
				}
			}
			echo end of if me is dead
		}
		else
		{	
			if ((${Stucky}>59 || ${Me.InventorySlotsFree}<1) && !${Me.InCombatMode})
			{
				echo Aborting current Zone (${sQN}), please wait
				if ${Script["autoshinies"](exists)}
					endscript autoshinies
				call StopHunt
				call EndZone
				if (${Heroic})
				{
					Me.Inventory["Mechanized Platinum Repository of Reconstruction"]:Use
					wait 50
					echo Repair
					oc !c -repair
					wait 50
					call RunZone 0 0 0 ${NoShiny}
				}
				else
				{
					call goto_GH
					call GuildH
					wait 100
					call goCoV
					if (!${Script["LoopSolo"](exists)} && !${Heroic})
						run EQ2Ethreayd/LoopSolo
					if (!${Script["LoopHeroic"](exists)} && ${Heroic})
						run EQ2Ethreayd/LoopHeroic
				}
			}
		}
		echo will restart a ldr loop (Restart at ${Restart})
	}
	while (TRUE)
}