#include "${LavishScript.HomeDirectory}/Scripts/tools.iss"

function main(string Loop)
{
	variable string ToonName
	ToonName:Set[${Me.Name}]
	OgreBotAPI:Revive[${Me.Name}]
	wait 300
	call goto_GH
	echo Repair
	OgreBotAPI:RepairGear[${Me.Name}]
	wait 300
	echo Depot
	ogre depot -allh -hda -llda -cda
	wait 300
	echo Shinies
	runscript gardener
	wait 1500
	echo Depot Shinies
	ogre depot -cda
	wait 300
	UIElement[OgreTaskListTemplateUIXML].FindUsableChild[button_clearerrors,button]:LeftClick	
	wait 30
	ogre plant -t ${ToonName}
	wait 1200
	ogre ${ToonName}
	wait 900
	call goto_GH
	wait 600
	ogre depot -allh -hda -llda -cda
	wait 300
	OgreBotAPI:ApplyVerbForWho["${Me.Name}","Large Ulteran Spire","Voyage Through Norrath"]
	wait 100
	OgreBotAPI:Travel["${Me.Name}", "Plane of Magic"]
	call waitfor_Zone "Plane of Magic"
	run ${Loop}
	run oopsimdead ${Loop}
}