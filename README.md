# eq2xp
Lavishscript for ISXE2 and OSXOgre to play EverQuest 2 (EQ2)

# Dependancies
You will need Innerspace, ISXEQ2 module as well as ISXOgre & ISXRI(optional) to use this code 

# Run Solo Blood of Luclin
* If you are using ISXRI, type run EQ2Ethreayd/BoLLoop
You need to have configured ISXRI RZ before launching BoLLoop

* If you want to use Ogre only (ogre ic), type run EQ2Ethreayd/BoLLoop TRUE

For now, BoLLoop works better with ISXRI but I am working on that

# Run Signature Quest (Legacy of Power)
- type "run EQ2Ethreayd/autopop"

This will adapt the speed to your toon class (mage and scouts will move very slowly in instances)

You can override that by doing "run EQ2Ethreayd/autopop 0 0 3" to run through instances

Shinies will not be gathered yet, but will be in instances done one by one

# Run an instance (and collect shinies)
- type "run EQ2Ethreayd/wrap RunZone" inside instance

To avoid collecting Shinies type "run EQ2Ethreayd/wrap RunZone 0 0 0 TRUE"

To do the instance faster type "run EQ2Ethreayd/wrap RunZone 0 0 3 TRUE"
