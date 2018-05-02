function main()
{
   variable string MerchantName
   MerchantName:Set["Turns Looted Fertilizer into Shines"]
   if !${Actor["${MerchantName}"](exists)}
   {
      echo ${Time}: ${MerchantName} not found.
      Script:End
   }
   if ${Actor["${MerchantName}"].Distance} > 20
   {
      echo ${Time}: ${MerchantName} too far away ( ${Actor["${MerchantName}"].Distance} ) > 20.
      Script:End
   }
   else
   {
   Actor["${MerchantName}"]:DoFace
   }

   ;// Make sure we have at least ONE inventory slot available.
   if ${Me.InventorySlotsFree} <= 0
   {
      echo ${Time}: You don't have any inventory slots free! You need at least 1 free slot to continue.
      Script:End
   }
   
   ;// We we create a loop to buy. It's possible we will only loop once, or we may have to loop more than once.
   ;// Create a variable, we can stop looping.
   variable int toCollect=0
   toCollect:Set[${Me.InventorySlotsFree}]
   variable int Collected=0
	
   
   ;// Loop as long as we're not suppose to stop (StopLooping) and as long as there are more bags to buy.
   while ${Collected} <= ${toCollect}
   {
      ;// Target the merchant.
      Actor["${MerchantName}"]:DoTarget
      Actor["${MerchantName}"]:DoubleClick
      wait 5
      EQ2UIPage[ProxyActor,Conversation].Child[composite,replies].Child[button,1]:LeftClick
         variable int RandomDelay
         RandomDelay:Set[ ${Math.Rand[3]} ]
         RandomDelay:Inc[5]
         wait ${RandomDelay}
      Collected:Inc[1]
   }
}