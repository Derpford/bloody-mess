class BloodyHealBonus : HealthBonus replaces HealthBonus
{
	// To make up for the health drain over time, this health bonus gives 3 points of health.
	mixin Spinner;
	mixin ShowAmount;
	default
	{
		Inventory.Amount 3;
		Inventory.PickupMessage "Health bonus!";
	}
}

class BloodyStimpack : Stimpack replaces Stimpack
{
	mixin Spinner;
	mixin ShowAmount;

	default
	{
		Inventory.Amount 15;
		Inventory.PickupMessage "Stimpack! +15 health!";
	}
}

class BloodyMedkit : Medikit replaces Medikit
{
	mixin Spinner;
	mixin ShowAmount;

	default
	{
		Inventory.Amount 30;
		Inventory.PickupMessage "Medkit! +30 health!";
		Health.LowMessage 25, "Medkit! What a lifesaver!";
	}
}

class BloodyArmorBonus : ArmorBonus replaces ArmorBonus
{
	// So too for the armor bonus.
	mixin Spinner;
	mixin ShowAmount;
	default
	{
		Armor.SaveAmount 3;
		Armor.SavePercent 66.6; //heheh
		Inventory.PickupMessage "Armor bonus!";
	}
}

class BloodyArmorPlate : BloodyArmorBonus replaces GreenArmor
{
	default
	{
		Armor.SaveAmount 50;
		Inventory.PickupMessage "Grabbed an armor plate!";
	}

	states
	{
		Spawn:
			ARM1 AB 6 Bright;
			Loop;
	}
}

class BloodyArmorVest : BloodyArmorBonus replaces BlueArmor
{
	default
	{
		Armor.SaveAmount 100;
		Inventory.PickupMessage "Got an armor vest!";
	}

	states
	{
		Spawn:
			ARM2 AB 6 Bright;
			Loop;
	}
}