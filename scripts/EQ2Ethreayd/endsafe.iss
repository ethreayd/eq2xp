function main(string ScriptName)
{
	do
	{
		if (${Script["${ScriptName}"}](exists)})
			endscript ${ScriptName}
		wait 10
	}
	while (${Script["${ScriptName}"}](exists)})
}
