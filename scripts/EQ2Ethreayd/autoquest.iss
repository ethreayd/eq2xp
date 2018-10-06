#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"


function main(string Loop)
{
	variable string ToonName
	wait 600
	echo I am in ${Zone.Name}
	ToonName:Set[${Me.Name}]
	call StopHunt
	OgreBotAPI:Revive[${Me.Name}]
	wait 300
	call CastAbility "Call to Guild Hall"
	wait 600
	echo Shinies
	runscript EQ2Ethreayd/gardener
	wait 1500
	echo Depot Shinies
	ogre depot -cda
	wait 300
	UIElement[OgreTaskListTemplateUIXML].FindUsableChild[button_clearerrors,button]:LeftClick	
	wait 30
	;ogre plant -t ${ToonName}
	;wait 1200
	;ogre end plant
	;ogre ${ToonName}
	;wait 900
	;call CastAbility "Call to Guild Hall"
	;wait 600
	do
	{
		call Transmute "Planar Transmutation Stone"
		wait 10
		call CountItem "Planar Transmutation Stone"
	}
	while (${Return}>0)
	ogre depot -allh -hda -llda -cda
	wait 100
	oc !c -ArcannaseEffigyOfRebirth All
	wait 20
	oc !c -ArcannaseEffigyOfRebirth All
	wait 20
	call goCoV
	wait 100
	relay is1 run EQ2Ethreayd/${Loop}
}