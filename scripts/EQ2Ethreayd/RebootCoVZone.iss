#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	variable int Counter
	variable bool LR
	variable string ZoneName
			echo rebooting session
			call StopHunt
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
				default
					run loopPoI
				break
			}
}
