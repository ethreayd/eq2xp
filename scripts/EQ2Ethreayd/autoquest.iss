#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"


function main(string Loop)
{
	variable string ToonName
	echo I am in ${Zone.Name}
	ToonName:Set[${Me.Name}]
	call StopHunt
	OgreBotAPI:Revive[${Me.Name}]
	wait 300
	call goto_GH
	echo Repair
	OgreBotAPI:RepairGear[${Me.Name}]
	wait 300
	echo Depot
	ogre depot -allh -hda -llda -cda
	call DepositAll "Scroll Depot"
	wait 300
	echo Shinies
	runscript EQ2Ethreayd/gardener
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
	do
	{
		call Transmute "Planar Transmutation Stone"
		wait 10
		call CountItem "Planar Transmutation Stone"
	}
	while (${Return}>0)
	
	
	ogre depot -allh -hda -llda -cda
	wait 300
	OgreBotAPI:ApplyVerbForWho["${Me.Name}","Large Ulteran Spire","Voyage Through Norrath"]
	wait 100
	OgreBotAPI:Travel["${Me.Name}", "Plane of Magic"]
	call waitfor_Zone "Plane of Magic"
	run EQ2Ethreayd/${Loop}
	run EQ2Ethreayd/oopsimdead ${Loop}
}