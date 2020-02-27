#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/EQ2Travel.iss"


function main()
{
call goDercin_Marrbrand
call Converse "Dercin Marrbrand" 4
wait 20
call Converse "Dercin Marrbrand" 4
wait 20
call Converse "Dercin Marrbrand" 4
wait 20
Me.Inventory["Box of Tinkering Materials"]:Unpack
wait 20
Me.Inventory["Box of Adorning Materials"]:Unpack
wait 20
Me.Inventory["Box of Old Boots"]:Unpack
wait 20

call TransmuteAll "A worn pair of boots"
wait 20
call Converse "Dercin Marrbrand" 2
wait 20
call DMove 675 412 30 3
call AutoCraft "Work Bench" "Adornment of Guarding (Greater)" 10 TRUE "Daily Adorning"
wait 20
call AutoCraft "Work Bench" "All Purpose Sprocket" 10 TRUE "All Purpose Sprockets"
wait 20
call goDercin_Marrbrand
call Converse "Dercin Marrbrand" 2
wait 20
call Converse "Dercin Marrbrand" 2
wait 20
}
