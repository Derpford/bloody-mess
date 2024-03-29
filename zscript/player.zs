class BloodyMessPlayer : DoomPlayer
{
	// Our hero. Or monster, depending on who you ask. Sometimes the world doesn't need another hero.
	// Health over 100 ticks down slowly. So does armor over 100.
	int DrainTimer;

	default
	{
		Player.StartItem "Bolter";
		Player.StartItem "Coil",0;
		//+ALLOWTHRUBITS;
		//ThruBits 1;
		// Not compatible with lzdoom :(
	}

	override bool CanTouchItem(Inventory item)
	{
		DrainTimer = 35; // Resets the drain timer when you pick something up.
		return super.CanTouchItem(item);
	}
	override void Tick()
	{
		super.Tick();
		
		if(DrainTimer < 1)
		{
			if(health > 100)
			{
				A_SetHealth(health-1);
			}

			let myarmor = BasicArmor(FindInventory("BasicArmor"));
			if(myarmor && myarmor.Amount > 100)
			{
				myarmor.Amount -= 1;
			}

			DrainTimer = 35;
		}
		else
		{
			DrainTimer -= 1;
		}
	}
}