#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main(bool NoShiny)
{
	variable bool GroupDead
	variable bool GroupAlive
	variable float loc0
	variable int Counter
	variable int Stucky
	variable string sQN
	do
	{
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
				Counter:Inc
			else
				Counter:Set[0]
			call CheckStuck ${loc0}
			if (${Return})
				Stucky:Inc
			else
				Stucky:Dec
		}
		while (${GroupAlive} && !${GroupDead} && ${Counter}<30 && ${Stucky}<60)
		echo Live and let die ! (${GroupAlive} && !${GroupDead} && ${Counter}<30 && ${Stucky}<60)
		call strip_QN "${Zone.Name}"
		sQN:Set[${Return}]
		if (${Me.IsDead} && ${Me.InventorySlotsFree}>0)
		{
			wait 300
			if (${Me.IsDead})
			{
				echo I am Dead - Rebooting Instance
				if ${Script["autoshinies"](exists)}
					endscript autoshinies
				call StopHunt
				if ${Script[${sQN}](exists)}
					endscript ${sQN}
				wait 50
				press -release MOVEFORWARD
				OgreBotAPI:Revive[${Me.Name}]
				echo waiting 1 min to recover
				wait 600
				call ReturnEquipmentSlotHealth Primary
				if (${Return}<20)
				{
					echo Gear is too damaged - Ending this RunZone to mend
					call goto_GH
					call GuildH
					wait 100
					call goCoV
				}
				else
					call RunZone 0 0 0 ${NoShiny}
			}
		}
		else
		{
			if ((${Stucky}>59 || ${Me.InventorySlotsFree}<1) && !${Me.InCombatMode})
			{
				echo Aborting current Zone, please wait
				if ${Script["autoshinies"](exists)}
					endscript autoshinies
				call StopHunt
				if ${Script[${sQN}](exists)}
					endscript ${sQN}
				wait 50
				press -release MOVEFORWARD

				call goto_GH
				call GuildH
				wait 100
				call goCoV
				if (!${Script["LoopSolo"](exists)})
					run EQ2Ethreayd/LoopSolo
				
			}
		}
	}
	while (1==1)
}