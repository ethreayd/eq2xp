#define AUTORUN "num lock"
#define CENTER p
#define MOVEFORWARD w
#define MOVEBACKWARD s
#define STRAFELEFT q
#define STRAFERIGHT e
#define TURNLEFT a
#define TURNRIGHT d
#define FLYUP space
#define FLYDOWN x
#define PAGEUP "Page Up"
#define PAGEDOWN "Page Down"
#define WALK shift+r
#define ZOOMIN "Num +"
#define ZOOMOUT "Num -"
#define JUMP Space
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"


function main()
{
	do
	{
		call IsPresent "Movable Molten Rock" 30
		if (${Return})
		{
			oc !c -pause ${Me.Name}
			Me.Inventory["Magmucus"]:Use
			call MoveCloseTo "Movable Molten Rock"
			call PKey F9 5
			call ActivateVerbOn "Movable Molten Rock" "Pick up"
			eq2execute gsay going to the Brazier NOW!
			call DMove 64 -120 -219 3 30 TRUE TRUE
			MouseTo 1020,440
			wait 10
			Mouse:LeftClick
			Mouse:LeftClick
			MouseTo 1360,650
			wait 10
			Mouse:LeftClick
			Mouse:LeftClick
			call PKey F9 5
			MouseTo 1020,440
			wait 10
			Mouse:LeftClick
			Mouse:LeftClick
		}
		else		
			oc !c -resume ${Me.Name}
	}
	while (TRUE)
}