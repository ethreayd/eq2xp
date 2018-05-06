#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

#define AUTORUN "num lock"
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
#define WALK shift+r
#define ZOOMIN "Num +"
#define ZOOMOUT "Num -"
variable(script) bool Windy

function main()
{
	Event[EQ2_onIncomingChatText]:AttachAtom[HandleEvents]
	Event[EQ2_onIncomingText]:AttachAtom[HandleAllEvents]
	call ActivateVerb "crypt_18" 521 70 -30 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_14" 537 68 -46 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_15" 530 68 -49 "Reach for the crypt" TRUE TRUE
	call ActivateVerb "crypt_20" 518 68 -47 "Reach for the crypt" TRUE TRUE

}

atom HandleAllEvents(string Message)
{
	;echo Catch Event ${Message}
	if (${Message.Find["has killed you"]} > 0 || ${Message.Find["you have died"]} > 0)
	{
		echo "I am dead"
		if ${Script["livedierepeat"](exists)}
			endscript livedierepeat
		run EQ2Ethreayd/livedierepeat
	}
	if (${Message.Find["feel unsteady on your feet"]} > 0)
	{
		Windy:Set[TRUE]
	}
}