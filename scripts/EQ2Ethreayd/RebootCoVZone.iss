#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	variable int Counter
	variable bool LR
	variable string ZoneName
			echo rebooting session
			call StopHunt
			run EQ2Ethreayd/killall
			ZoneName:Set["${Zone.Name}"]
			call PKey MOVEFORWARD 1
			OgreBotAPI:Revive[${Me.Name}]
			wait 300
			OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
			call goto_GH
			wait 100
			OgreBotAPI:RepairGear[${Me.Name}]
			wait 100
			ogre depot -allh -hda -llda -cda
			wait 100
			OgreBotAPI:RepairGear[${Me.Name}]
			wait 100
			OgreBotAPI:ApplyVerbForWho["${Me.Name}","Large Ulteran Spire","Voyage Through Norrath"]
			wait 100
			OgreBotAPI:CancelMaintained["${Me.Name}","Singular Focus"]
			OgreBotAPI:RepairGear[${Me.Name}]
			OgreBotAPI:Travel["${Me.Name}", "Plane of Magic"]
			call waitfor_Zone "Plane of Magic"
			call goCoV
			call DMove -2 5 4 3
			switch ${Zone.Name}
			{
				case "Plane of Magic"
					call goCoV
				break
				case "Plane of Innovation: Masks of the Marvelous [Solo]"
					run loopPoI
				case "Plane of Innovation: Gears in the Machine [Solo]"
					run loopPoI
				case "Plane of Disease: Outbreak [Solo]"
					run loopPoD
				case "Plane of Disease: the Source [Solo]"
					run loopPoD
				case "Torden, Bastion of Thunder: Tower Breach [Solo]"
					run loopBoT
				case "Torden, Bastion of Thunder: Winds of Change [Solo]"
					run loopBoT
				default
					run loopPIDT
				break
			}
}
