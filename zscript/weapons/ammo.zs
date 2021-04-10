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
	}

	states
	{
		Spawn:
			NAMO A 0;
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
	}

	states
	{
		Spawn:
			NBOX A 0;
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
	}

	states
	{
		Spawn:
			WAMC AB 4;
			Loop;
	}
}