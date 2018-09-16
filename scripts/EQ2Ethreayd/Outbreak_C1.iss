#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	do
	{
		wait 10
	}
	while (1==1)
}

atom HandleAllEvents(string Message)
{
	;echo Catch Event ${Message}
	if (${Message.Find["check detriment"]} > 0 && ${Message.Find["${Me.Name}"]} > 0)
	{
		call CheckDetriment "Awakened Affliction"
		if (${Return})
			eq2execute gsay need ordered cure
	}
}