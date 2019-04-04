#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"
function main(int64 ReqPotency)
{
	variable int64 MyPotency
	
	call get_Potency
	MyPotency:Set[${Return}]
			
	if (${MyPotency}<${ReqPotency})
	{
		echo Potency is too low (${MyPotency}<${ReqPotency}), using Elixir now
		wait ${Math.Rand[600]}
		oc !c -UseItem ${Me.Name} "Elixir of the Expert"
		wait 50
		call get_Potency
		eq2execute gsay ${Me.Name} at ${Return} Potency
	}
	else
		eq2execute gsay ${Me.Name} at ${MyPotency} Potency (requirement is ${ReqPotency})
}