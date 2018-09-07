#include "${LavishScript.HomeDirectory}/Scripts/EQ2Ethreayd/tools.iss"

function main()
{
	echo launching assistant script TBoTTBH_C4 to pass tornado
	do
	{
		wait 10
	}
	while (${Actor["a virulent sandstorm"].Z} < -748 && ${Actor["a virulent sandstorm"].Z} > -790)
	echo "GO GO GO"
	call DMove -813 345 -740 3 5 TRUE TRUE
}
