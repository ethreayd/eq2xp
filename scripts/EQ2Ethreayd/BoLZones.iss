function EnterZone(int num)
{
/*
	do
	{
		OgreBotAPI:ZoneDoorForWho["${Me.Name}",${num}]
		wait 50
	}
	while (${Zone.Name.Equal["Coliseum of Valor"]})
*/
}

function getQuests(string ZoneName, string version)
{
/*
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
*/
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
	;OgreBotAPI:Travel["${Me.Name}", "Plane of Magic"]
	;call waitfor_Zone "Plane of Magic"
	;call goCoV
	call DMove -2 5 4 3
	;run EQ2Ethreayd/autopop
}
