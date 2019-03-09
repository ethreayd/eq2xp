function EnterZone(int num)
{
	do
	{
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",${num}]
		wait 50
	}
	while (${Zone.Name.Equal["Coliseum of Valor"]})
}
function getQuests(string ZoneName, string version)
{
	variable string NPCName
	if (${Me.Y}<400 || ${Me.Y}>430)
		call goEPG
	call DMove 751 411 -364 3
	
	switch ${ZoneName}
	{
		default
		{
			call MoveCloseTo "Researcher Tulvina"
			target "Researcher Tulvina"
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			target "Quillion Frain"
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			target "Vazgron the Loremonger"
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			target "a Planar Chronicler Vol. 2"
			call MoveCloseTo "a Planar Chronicler Vol. 2"
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,5]:LeftClick
			
			target "a Planar Chronicler Vol. 2"
			call MoveCloseTo "a Planar Chronicler Vol. 2"
			eq2execute hail
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,3]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,2]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
			wait 10
			EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
		}
		break
	}
}	
function goMyrist()
{
	variable string ZoneName
	ZoneName:Set["Myrist, the Great Library"]
	if (${Zone.Name.Right[10].Equal["Guild Hall"]})
	{
		call ActivateSpire
		wait 50
		OgreBotAPI:Travel["${Me.Name}", "${ZoneName}"]
		RIMUIObj:TravelMap["${Me.Name}","Myrist",1,2]
		wait 300
	}
	
	if (!${Zone.Name.Right[10].Equal["Guild Hall"]} && !${Zone.Name.Left[25].Equal["${ZoneName}"]})
	{
		call goto_GH
		wait 600
		call goMyrist
	}
	call waitfor_Zone "${ZoneName}"
}
function goEPG()
{
	call goMyrist
	call DMove 71 -20 -13 3
	call DMove 134 -5 -11 3
	call DMove 170 -5 -101 3
	call DMove 221 -5 -138 3
	call DMove 217 -5 -158 3
	call DMove 204 -20 -196 3
	call DMove 204 -20 -254 3
	call DMove 249 -20 -256 3
	call DMove 257 -20 -286 3
	wait 20
	call ActivateVerbOn "Teleporter to Elemental Portal Gallery" Touch TRUE
	wait 100
}
function goPublicZone(string ZoneName)
{
	variable string LongZoneName
	
	if ((${Zone.Name.Left[6].Equal["Myrist"]} || ${Zone.Name.Right[10].Equal["Guild Hall"]}) && (${Me.Y}<400 || ${Me.Y}>430))
		call goEPG
	
	switch ${ZoneName}
	{
		case Doomfire
		{
			LongZoneName:Set["Doomfire, the Burning Lands"]
			echo Going to ${ZoneName} (${LongZoneName})
			call DMove 730 412 -338 3
			call ActivateVerbOn "zone_to_pof" "Enter ${LongZoneName}" TRUE	
		}
		break
		default
		{
			LongZoneName:Set["Vegarlson, the Earthen Badlands"]
			echo no Zone selected going to ${ZoneName} (${LongZoneName})
			call DMove 771 412 -338 3
			call ActivateVerbOn "zone_to_poe" "Enter ${LongZoneName}" TRUE
		}
		break
	}
	wait 20
	oc !c -ZoneDoor 1
	RUIMObj:Door[${Me.Name},1]
	call waitfor_Zone "${LongZoneName}"
}
function MendToon()
{
	call ReturnEquipmentSlotHealth Primary
	if (${Return}<100)
	{
		echo NOT IMPLEMENTED YET
	}
}
function PrepareToon()
{
	call GetQuests
	call MendToon
}

function RebootZones()
{
	variable int Counter
	variable bool LR
	echo rebooting session
	call StopHunt
	oc !c -letsgo ${Me.Name}
	run EQ2Ethreayd/killall
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
	run EQ2Ethreayd/autopop
}
