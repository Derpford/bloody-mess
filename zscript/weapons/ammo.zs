class Nail : Ammo replaces Shell
{
	// Individual nails.

	mixin Spinner;

	default
	{
		Scale 0.5;
		Inventory.Amount 2;
		Inventory.MaxAmount 50;
		Ammo.BackpackAmount 100;
		Inventory.PickupMessage "Grabbed some nails.";
	}

	states
	{
		Spawn:
			NAMO A -1;
			Stop;
	}
}

class NailBox : Nail
{
	// Box o' Nails.

	mixin Spinner;

	default
	{
		Scale 1;
		Inventory.Amount 10;
		Inventory.PickupMessage "Got a box of nails.";
	}

	states
	{
		Spawn:
			NBOX A -1;
			Stop;
	}
}

class Coil : Ammo replaces Clip
{
	// A small coilgun ammo pack.
	mixin Spinner;

	default
	{
		Scale 1;
		Inventory.Amount 10;
		Inventory.MaxAmount 300;
		Ammo.BackpackAmount 600;
		Inventory.PickupMessage "Grabbed a coil charge pack.";
	}

	states
	{
		Spawn:
			WAMC AB 4;
			Loop;
	}
}

class CoilCase : Coil replaces ClipBox

{
	// A case of coilgun charges.
	mixin Spinner;

	default
	{
		Scale 1;
		Inventory.Amount 60;
		Inventory.PickupMessage "Grabbed a case of coil charges.";
	}

	states
	{
		Spawn:
			WAMC CD 4;
			Loop;
	}
}