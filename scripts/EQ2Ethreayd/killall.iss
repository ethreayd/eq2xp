function main()
{
	variable index:string ScriptsToRun
	variable string sQN
	variable int x
	ScriptsToRun:Insert["TheFabledRuinsofGukHallsoftheFallen_Group_"]
	ScriptsToRun:Insert["PlaneofDiseaseInfestedMesa_Group_"]
	ScriptsToRun:Insert["PlaneofInnovationGearsintheMachine_Group_"]
	ScriptsToRun:Insert["SolusekRosTowerTheObsidianCore_Group_"]
	ScriptsToRun:Insert["PlaneofDiseaseOutbreak_Group_"]
	ScriptsToRun:Insert["TheFabledRuinsofGukHallsoftheFallen_Solo_"]
	ScriptsToRun:Insert["loopSoH"]
	ScriptsToRun:Insert["ShardofHateUtterContempt_Group_"]
	ScriptsToRun:Insert["TBoTTBH_C1"]
	ScriptsToRun:Insert["SRTTOC_C1"]
	ScriptsToRun:Insert["Outbreak_C1"]
	ScriptsToRun:Insert["test"]
	ScriptsToRun:Insert["PlaneofInnovationMasksoftheMarvelous_Group_"]
	ScriptsToRun:Insert["ShardofHateUtterContempt_Solo_"]
	ScriptsToRun:Insert["TordenBastionofThunderTowerBreach_Group_"]
	ScriptsToRun:Insert["PlaneofInnovationSecurityMeasures_tradeskill_"]
	ScriptsToRun:Insert["AStitchinTimePartISecurityMeasures"]
	ScriptsToRun:Insert["ConservationofPlanarEnergy"]
	ScriptsToRun:Insert["TheMoltenThrone"]
	ScriptsToRun:Insert["LegacyofPowerTyrantsThrone"]
	ScriptsToRun:Insert["BrackishVaults_Solo_"]
	ScriptsToRun:Insert["autoshinies"]
	ScriptsToRun:Insert["LegacyofPowerDeepTrouble"]
	ScriptsToRun:Insert["SolusekRosTowerMonolithofFire_Solo_"]
	ScriptsToRun:Insert["SolusekRosTowerTheObsidianCore_Solo_"]
	ScriptsToRun:Insert["LegacyofPowerDrawntotheFire"]
	ScriptsToRun:Insert["LegacyofPowerGlimpseoftheHereother"]
	ScriptsToRun:Insert["TordenBastionofThunderWindsofChange_Solo_"]
	ScriptsToRun:Insert["TordenBastionofThunderTowerBreach_Solo_"]
	ScriptsToRun:Insert["LegacyofPowerThroughStormsandMists"]
	ScriptsToRun:Insert["ToonAssistant"]
	ScriptsToRun:Insert["wrap"]
	ScriptsToRun:Insert["RestartZone"]
	ScriptsToRun:Insert["deathwatch"]
	ScriptsToRun:Insert["loopHeroic"]
	ScriptsToRun:Insert["loopSolo"]
	ScriptsToRun:Insert["loopSRT"]
	ScriptsToRun:Insert["loopBoT"]
	ScriptsToRun:Insert["loopPIDT"]
	ScriptsToRun:Insert["loopPoID"]
	ScriptsToRun:Insert["loopPoD"]	
	ScriptsToRun:Insert["PlaneofDiseaseTheSource_Solo_"]
	ScriptsToRun:Insert["loopPoI"]
	ScriptsToRun:Insert["PlaneofDiseaseOutbreak_Solo_"]
	ScriptsToRun:Insert["LegacyofPowerRealmofthePlaguebringer"]
	ScriptsToRun:Insert["PlaneofInnovationMasksoftheMarvelous_Solo_"]
	ScriptsToRun:Insert["LegacyofPowerAnInnovativeApproach"]
	ScriptsToRun:Insert["PlaneofInnovationGearsintheMachine_Solo_"]
	ScriptsToRun:Insert["LegacyofPowerHerosDevotion"]
	ScriptsToRun:Insert["LegacyofPowerSecretsinanArcaneLand"]
	ScriptsToRun:Insert["autopop"]

	for ( x:Set[1] ; ${x} <= ${ScriptsToRun.Used} ; x:Inc )
	{
        
		if ${Script["${ScriptsToRun[${x}]}"](exists)}
		{
			echo Killing script ${ScriptsToRun[${x}]}
			endscript "${ScriptsToRun[${x}]}"		
		}
	}
	press -release w
	oc !c -letsgo
	
}