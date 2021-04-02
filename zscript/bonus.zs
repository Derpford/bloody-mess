class BloodyHealBonus : HealthBonus replaces HealthBonus
{
	// To make up for the health drain over time, this health bonus gives 3 points of health.
	default
	{
		Inventory.Amount 3;
	}
}

class BloodyArmorBonus : ArmorBonus replaces ArmorBonus
{
	// So too for the armor bonus.
	default
	{
		Armor.SaveAmount 3;
	}
}