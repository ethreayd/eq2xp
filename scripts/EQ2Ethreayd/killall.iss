function main()
{
	variable index:string ScriptsToRun
	variable string sQN
	
	ScriptsToRun:Insert["LegacyofPowerDeepTrouble"]
	ScriptsToRun:Insert["SolusekRosTowerTheObsidianCore_Solo_"]
	ScriptsToRun:Insert["LegacyofPowerDrawntotheFire"]
	ScriptsToRun:Insert["LegacyofPowerGlimpseoftheHereother"]
	ScriptsToRun:Insert["TordenBastionofThunderWindsofChange_Solo_"]
	ScriptsToRun:Insert["TordenBastionofThunderTowerBreach_Solo_"]
	ScriptsToRun:Insert["LegacyofPowerThroughStormsandMists"]
	ScriptsToRun:Insert["loopPoID"]
	ScriptsToRun:Insert["loopPoD"]	
	ScriptsToRun:Insert["PlaneofDiseasetheSource_Solo_"]
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