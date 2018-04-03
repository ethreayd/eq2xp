function main()
{
	variable index:string ScriptsToRun
	variable string sQN
	ScriptsToRun:Insert["PoD-O_Solo"]
	ScriptsToRun:Insert["LegacyofPowerRealmofthePlaguebringer"]
	ScriptsToRun:Insert["PoI-GitM_Solo"]
	ScriptsToRun:Insert["LegacyofPowerAnInnovativeApproach"]
	ScriptsToRun:Insert["PoI-MotM_Solo"]
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