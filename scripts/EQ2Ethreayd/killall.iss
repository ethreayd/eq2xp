function main()
{
	variable index:string ScriptsToRun
	variable string sQN
	ScriptsToRun:Insert["loopSoH"]
	ScriptsToRun:Insert["ShardofHateUtterContempt_Heroic_"]
	ScriptsToRun:Insert["Outbreak_C1"]
	ScriptsToRun:Insert["test"]
	ScriptsToRun:Insert["PlaneofDiseaseOutbreak_Heroic_"]
	ScriptsToRun:Insert["PlaneofInnovationMasksoftheMarvelous_Expert_"]
	ScriptsToRun:Insert["ShardofHateUtterContempt_Solo_"]
	ScriptsToRun:Insert["TordenBastionofThunderTowerBreach_Heroic_"]
	ScriptsToRun:Insert["PlaneofInnovationMasksoftheMarvelous_Heroic_"]
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
	ScriptsToRun:Insert["wrap"]
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
	

	variable int x
	for ( x:Set[1] ; ${x} <= ${ScriptsToRun.Used} ; x:Inc )
	{
        echo Killing script ${ScriptsToRun[${x}]}
		if ${Script["${ScriptsToRun[${x}]}"](exists)}
			endscript "${ScriptsToRun[${x}]}"
	}
}